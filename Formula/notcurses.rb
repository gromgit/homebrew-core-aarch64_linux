class Notcurses < Formula
  desc "Blingful character graphics/TUI library"
  homepage "https://nick-black.com/dankwiki/index.php/Notcurses"
  url "https://github.com/dankamongmen/notcurses/archive/refs/tags/v2.4.4.tar.gz"
  sha256 "dcd084b8ff516defd10840936aebec9b822fb622f0232cc79be7b8826252aad5"

  license "Apache-2.0"

  bottle do
    sha256 arm64_big_sur: "580b62725852d976784cf969ace431d14a78abade1a87374b52496d82af5c85b"
    sha256 big_sur:       "7aaec2ea87abfef01576270342385f4263a4b5015bc5beb45d091375fcf7f0ab"
    sha256 catalina:      "97eaf667f5420c6a93cf15e76cb440cfba387c1971a11f799e1242e758175320"
    sha256 mojave:        "ef8fa3cfe6b986618342366bd6e5976848728820ccc569ae8c34e965215da531"
  end

  depends_on "cmake" => :build
  depends_on "doctest" => :build
  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "libunistring"
  depends_on "ncurses"
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
