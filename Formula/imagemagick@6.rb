class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://legacy.imagemagick.org/"
  url "https://imagemagick.org/archive/releases/ImageMagick-6.9.12-60.tar.xz"
  sha256 "9b23870a2d6116be045b6788c5d88ec66690a3a839ce23b8dd89d547bb3a5b31"
  license "ImageMagick"
  head "https://github.com/imagemagick/imagemagick6.git", branch: "main"

  livecheck do
    url "https://imagemagick.org/archive/"
    regex(/href=.*?ImageMagick[._-]v?(6(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "97a0ca465c19dd6ed50da5fe8e0d3896539e8846b633145c9d59455e016b153c"
    sha256 arm64_big_sur:  "06d24a721cb274537503f54a71b682729c4141b83200ade128fadee1187c9062"
    sha256 monterey:       "2ad22c979f50852981db3a3b046a145b0c05a0dbad956c31367797973b5c9082"
    sha256 big_sur:        "21f5c64a6dda2ae55c3a88e4ff7a2544e867df1043d5835c09ab4e4e72cfe5d6"
    sha256 catalina:       "7d7203d3a44a9b1b022822a0613d877a0a3406d960c2a24111f6cbc69b580a04"
    sha256 x86_64_linux:   "4a9ba33619d4e9833624780127c04df1a0f366fb349c331f1379a8fbe22f0f5d"
  end

  keg_only :versioned_formula

  depends_on "pkg-config" => :build

  depends_on "freetype"
  depends_on "ghostscript"
  depends_on "jpeg-turbo"
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
