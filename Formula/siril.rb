class Siril < Formula
  desc "Astronomical image processing tool"
  homepage "https://www.siril.org"
  url "https://free-astro.org/download/siril-0.9.12.tar.bz2"
  sha256 "9fb7f8a10630ea028137e8f213727519ae9916ea1d88cd8d0cc87f336d8d53b1"
  revision 6
  head "https://gitlab.com/free-astro/siril.git"

  bottle do
    sha256 "b20f65cc40cfefeef4700ab6ebba10d6c2f1b63688f897b99df6f9309fa0846e" => :catalina
    sha256 "230814b7af2589bdd2c17b441fa3a83fc094cfb9c70cd30a22af775905e7748f" => :mojave
    sha256 "53dcd2d36c0fc7cbe5b71b9e545e1278659460fc7744cdaff42f9c26b3b00666" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "intltool" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "cfitsio"
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
    system "make", "install"
  end

  test do
    system "#{bin}/siril", "-v"
  end
end
