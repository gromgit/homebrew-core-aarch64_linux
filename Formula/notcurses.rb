class Notcurses < Formula
  desc "Blingful character graphics/TUI library"
  homepage "https://nick-black.com/dankwiki/index.php/Notcurses"
  url "https://github.com/dankamongmen/notcurses/archive/refs/tags/v2.3.16.tar.gz"
  sha256 "4560e273b7f965d309cd436ed6702bd1b83a2976c0dd7e0205fee9bf52f138cf"

  license "Apache-2.0"

  bottle do
    sha256 arm64_big_sur: "cec298c56c1b6ae574a91ad64e606bbff7f8f4b1dc3634c4d873d66332d8b5b6"
    sha256 big_sur:       "d3ccf77415d1575c11c8e1e4c39150a7942e802e29bd7209341d4323a42e609e"
    sha256 catalina:      "5acb192986f425945fa2fc3dded530b64c48075534d1a78e5889c8a81708d686"
    sha256 mojave:        "596d4da953dd1c20455ebbf0f97212a3027517cf299a48edcf8acb417a53f81a"
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
