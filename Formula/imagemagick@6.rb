class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://legacy.imagemagick.org/"
  url "https://imagemagick.org/archive/releases/ImageMagick-6.9.12-59.tar.xz"
  sha256 "19f2a04f20d1ca3fe35cbf31c31ccac4ba7b99053c96901a9bb997efc8b4c6a0"
  license "ImageMagick"
  head "https://github.com/imagemagick/imagemagick6.git", branch: "main"

  livecheck do
    url "https://imagemagick.org/archive/"
    regex(/href=.*?ImageMagick[._-]v?(6(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "4ba0e35dd1796ae1c5e0cc23eeaf7a3a4201a0a0e7ca1e0233fbf4e6f8b4ed97"
    sha256 arm64_big_sur:  "0d5b0d002efd3fded46e19300f65dcb95874c009ab7332962fc8ae062064e800"
    sha256 monterey:       "1db1e2c650fd3ea06874d8e227dba7315a4f612f08356b38c7b9094c3d400868"
    sha256 big_sur:        "ab7bcd7e867ec7b092e820c2519fde81413b4d285472b4a05b46182120bb943b"
    sha256 catalina:       "8bde490e2b672d213d544abe38f356fc8f362e934e4eb1397061231c60e4fb5c"
    sha256 x86_64_linux:   "bbbd18c470aef0de6c72b0d2b88400a570ddea0fec2b1d4164424c2ef4c94031"
  end

  keg_only :versioned_formula

  depends_on "pkg-config" => :build

  depends_on "freetype"
  depends_on "ghostscript"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "libtool"
  depends_on "little-cms2"
  depends_on "openjpeg"
  depends_on "webp"
  depends_on "xz"

  skip_clean :la

  def install
    # Avoid references to shim
    inreplace Dir["**/*-config.in"], "@PKG_CONFIG@", Formula["pkg-config"].opt_bin/"pkg-config"

    args = %W[
      --enable-osx-universal-binary=no
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-silent-rules
      --disable-opencl
      --disable-openmp
      --enable-shared
      --enable-static
      --with-freetype=yes
      --with-modules
      --with-webp=yes
      --with-openjp2
      --with-gslib
      --with-gs-font-dir=#{HOMEBREW_PREFIX}/share/ghostscript/fonts
      --without-fftw
      --without-pango
      --without-x
      --without-wmf
    ]

    # versioned stuff in main tree is pointless for us
    inreplace "configure", "${PACKAGE_NAME}-${PACKAGE_BASE_VERSION}", "${PACKAGE_NAME}"
    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match "PNG", shell_output("#{bin}/identify #{test_fixtures("test.png")}")
    # Check support for recommended features and delegates.
    features = shell_output("#{bin}/convert -version")
    %w[Modules freetype jpeg png tiff].each do |feature|
      assert_match feature, features
    end
  end
end
