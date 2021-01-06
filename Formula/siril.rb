class Siril < Formula
  desc "Astronomical image processing tool"
  homepage "https://www.siril.org"
  url "https://free-astro.org/download/siril-0.99.6.tar.bz2"
  sha256 "255dbffb72bb39b1d9d56ab948b4cad32d1458161b1d997cd84ada21f9a8499f"
  license "GPL-3.0-or-later"
  revision 4
  head "https://gitlab.com/free-astro/siril.git"

  bottle do
    sha256 "203c9cc07bfd240147e388becdc8a98dd59f6f81e60574be4c8987c3fc223dfa" => :big_sur
    sha256 "17801c27fad74c686f56759c6acd1481f89ba4a441f7a32a2ba226a3f5cb2d92" => :catalina
    sha256 "73e2b5f9b0cf0f446710d634c099238f95f72a9bc598784856c45a76f3248479" => :mojave
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "intltool" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "cfitsio"
  depends_on "exiv2"
  depends_on "ffms2"
  depends_on "fftw"
  depends_on "gnuplot"
  depends_on "gsl"
  depends_on "gtk-mac-integration"
  depends_on "jpeg"
  depends_on "libconfig"
  depends_on "libomp"
  depends_on "libraw"
  depends_on "librsvg"
  depends_on "libsvg"
  depends_on "netpbm"
  depends_on "opencv"
  depends_on "openjpeg"

  def install
    # siril uses pkg-config but it has wrong include paths for several
    # headers. Work around that by letting it find all includes.
    ENV.append_to_cflags "-I#{HOMEBREW_PREFIX}/include -Xpreprocessor -fopenmp -lomp"

    system "./autogen.sh", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/siril", "-v"
  end
end
