class Notcurses < Formula
  desc "Blingful character graphics/TUI library"
  homepage "https://nick-black.com/dankwiki/index.php/Notcurses"
  url "https://github.com/dankamongmen/notcurses/archive/v3.0.3.tar.gz"
  sha256 "3be27640578f5b79c921d018cb14448867326737bc0d512c9f11c047dc9e478a"
  license "Apache-2.0"

  bottle do
    sha256 arm64_monterey: "0be2a01d5a602f1af05d73fcac023853396087d43797fe8a24696e7d56af52ec"
    sha256 arm64_big_sur:  "0d0658a89ceae0605c6ebfebab0e6dbeeb9b1b1a52e9c8b3b553ba3e974e2413"
    sha256 monterey:       "0faba8f53d6ca2925a8e4692fa0343db69cc08154c79742caa1df033ace13919"
    sha256 big_sur:        "9278a339565c8db75d2cbec56fb247f0940b8fa449fe9bfff5fdd545823c1adf"
    sha256 catalina:       "fbeb556e303bc06f5616fd26683f187b60b111024ce94bba8110cd623098bdf9"
    sha256 x86_64_linux:   "1b3fd3b7e10807be424ccc29ea4b37bffb84e502258aec7f379e0f23eccb26ee"
  end

  depends_on "cmake" => :build
  depends_on "doctest" => :build
  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "libdeflate"
  depends_on "libunistring"
  depends_on "ncurses"

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
