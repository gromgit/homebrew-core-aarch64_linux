class Siril < Formula
  desc "Astronomical image processing tool"
  homepage "https://www.siril.org"
  url "https://free-astro.org/download/siril-1.0.4.tar.bz2"
  sha256 "11aa4e491e42f606301d214ffec35741ac6522b5a94feab04fb701e829fd5aee"
  license "GPL-3.0-or-later"
  head "https://gitlab.com/free-astro/siril.git", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_monterey: "d465b3231d1ddbab8f18950081fec346ddb73156c03a12e8f3fabb88a3e6d350"
    sha256 arm64_big_sur:  "1455e68e9340e8f24f2fd24c4381a9979673d8a371cbdc27d3902128c0b24504"
    sha256 monterey:       "e540a0e960b6d46a31ccca757d2b214e30fb37df4da6647fff4187f2d60130a2"
    sha256 big_sur:        "ec230fac61723a6a7d7fa9d92ee4a6f710010c2e581bd97290fbcce62ae51ddb"
    sha256 catalina:       "6883ffffb4f2efcfd497b428f475ca5fbf81107daeaf684058546f19b9e35757"
    sha256 x86_64_linux:   "1f3a7e43e36830578db39bad3c06aa25cd59b6851755c48b9f8c2069306e7359"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
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
  depends_on "gtk+3"
  depends_on "jpeg-turbo"
  depends_on "json-glib"
  depends_on "libconfig"
  depends_on "libraw"
  depends_on "librsvg"
  depends_on "netpbm"
  depends_on "opencv"
  depends_on "openjpeg"

  uses_from_macos "perl" => :build

  on_macos do
    depends_on "gtk-mac-integration"
    depends_on "libomp"
  end

  fails_with gcc: "5" # ffmpeg is compiled with GCC

  def install
    ENV.prepend_path "PERL5LIB", Formula["intltool"].libexec/"lib/perl5" unless OS.mac?

    # siril uses pkg-config but it has wrong include paths for several
    # headers. Work around that by letting it find all includes.
    ENV.append_to_cflags "-I#{HOMEBREW_PREFIX}/include"
    ENV.append_to_cflags "-Xpreprocessor -fopenmp -lomp" if OS.mac?

    system "./autogen.sh", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"siril", "-v"
  end
end
