class Siril < Formula
  desc "Astronomical image processing tool"
  homepage "https://www.siril.org"
  url "https://free-astro.org/download/siril-0.99.4.tar.bz2"
  sha256 "80c0fcd750c034608464dfd443685ee51096df8b0b495d1743e6284d22f45f38"
  license "GPL-3.0-or-later"
  revision 1
  head "https://gitlab.com/free-astro/siril.git"

  bottle do
    sha256 "3e2facc0ace5466da9bf184b424b947198310216e5d18c32d8573a68d7d3eb1c" => :catalina
    sha256 "72a6f08ef2984f1deef657f8503050d2eef4a74c1f1246441b580674bd4f2344" => :mojave
    sha256 "d002c0aeb1481907ee85fd88dbd71149a1ef1e06af697c07f5142d57b6ab5f55" => :high_sierra
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
