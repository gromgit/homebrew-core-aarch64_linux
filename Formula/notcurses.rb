class Notcurses < Formula
  desc "Blingful character graphics/TUI library"
  homepage "https://nick-black.com/dankwiki/index.php/Notcurses"
  url "https://github.com/dankamongmen/notcurses/archive/refs/tags/v2.3.16.tar.gz"
  sha256 "4560e273b7f965d309cd436ed6702bd1b83a2976c0dd7e0205fee9bf52f138cf"

  license "Apache-2.0"

  bottle do
    sha256 arm64_big_sur: "b18687540a74c5737839af163951fbaa7d035fc18275dd6957b0d51fb5d7bb95"
    sha256 big_sur:       "ecaf74c8041f626ce976cb7de52f33e6e5ff6233b052cb7e62aaea960e624040"
    sha256 catalina:      "b3e67febe8d088c90977900f5fd80c6f6a1b0a240c9f97ab68dd980bf7de1d82"
    sha256 mojave:        "1063113309cbdad6cfb86163d4982bd3c70af7846a70ff2e126b6b9379f76bd6"
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

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # without the TERM definition, Notcurses is like a small child, lost in a
    # horrible mall. of course, if the tests are run in some non-xterm
    # environment, this choice might prove unfortunate.
    # you have no chance to survive. make your time.
    ENV["TERM"] = "xterm"
    assert_match "notcurses", shell_output("#{bin}/notcurses-info")
  end
end
