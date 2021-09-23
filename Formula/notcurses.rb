class Notcurses < Formula
  desc "Blingful character graphics/TUI library"
  homepage "https://nick-black.com/dankwiki/index.php/Notcurses"
  url "https://github.com/dankamongmen/notcurses/archive/refs/tags/v2.4.2.tar.gz"
  sha256 "f73bd2d3ec40d91729578b0a74c3228159bafcb09424cad85d9ba3fe18a2dca0"

  license "Apache-2.0"

  bottle do
    sha256 arm64_big_sur: "e8009e1962f45a26cdebab9ffe478563e14e9e37f06b9ff040302bb576f9b911"
    sha256 big_sur:       "a5142076093a30494edabf7fcf2b647f21ee6a7b224d3d2eb3843640dcdd33d1"
    sha256 catalina:      "f81ca79f14c688112cdfda74318d361a26322e54ff17b076f90d995181eed9f8"
    sha256 mojave:        "3e649c5830954bca7261f4e3e1b6e06f1ad8838dd4d01fdfdd6e85d5bfdd9af8"
  end

  depends_on "cmake" => :build
  depends_on "doctest" => :build
  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "libunistring"
  depends_on "ncurses"
  depends_on "readline"
  uses_from_macos "zlib"

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # current homebrew CI runs with TERM=dumb. given that Notcurses explicitly
    # does not support dumb terminals (i.e. those lacking the "cup" terminfo
    # capability), we expect a failure here. all output will go to stderr.
    assert_empty shell_output("#{bin}/notcurses-info", 1)
  end
end
