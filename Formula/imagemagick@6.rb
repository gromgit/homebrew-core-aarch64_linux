class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://legacy.imagemagick.org/"
  url "https://www.imagemagick.org/download/releases/ImageMagick-6.9.12-25.tar.xz"
  sha256 "e0c9956a4390c81c442152e446ac28c9f9808cf9f35241cd7a5f8be6381d0c8d"
  license "ImageMagick"
  revision 1
  head "https://github.com/imagemagick/imagemagick6.git"

  livecheck do
    url "https://download.imagemagick.org/ImageMagick/download/"
    regex(/href=.*?ImageMagick[._-]v?(6(?:\.\d+)+(?:-\d+)?)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "14d09d932883362a2a6cba8db73be94aa58c4ed39b1881d1b685489da4c57b94"
    sha256 big_sur:       "8466efcb49ce8b10df8a6de8aba8b9138b98b6c6fdb1137112aa1615f99a9146"
    sha256 catalina:      "4e1142336a0213154db42a8ccc96d6c7be7d7d9f734a3d0e7c45541589e9fa26"
    sha256 mojave:        "ef690f1f71c785a493ab44acbb756dfade1444393974a71c0fc8add2d46d413b"
    sha256 x86_64_linux:  "4eadcf601a15a4e2ef32b270cb9ed57f8733442b0720a68e6290a20417d256ac"
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
