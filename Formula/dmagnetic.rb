class Dmagnetic < Formula
  desc "Magnetic Scrolls Interpreter"
  homepage "https://www.dettus.net/dMagnetic/"
  url "https://www.dettus.net/dMagnetic/dMagnetic_0.29.tar.bz2"
  sha256 "a980e35f85c9661fe0d98c670f9d6be56000da2bbc8b3e8e78697eac05ae5b47"
  license "BSD-2-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "4e71323da4207dd754b6e7298cef93be779e1788460089a1ea5159383db3a602" => :big_sur
    sha256 "ca0509bc470f70a1cbefaa923ce7ae050588693505928be7e978d2690e7c2141" => :catalina
    sha256 "f75e5bbd19aa1ae5272dc6bfdd7654a9c09e2a2dcc11cc9b58180f8ffd61acf2" => :mojave
  end

  def install
    system "make", "PREFIX=#{prefix}", "install"
    (share/"games/dMagnetic").install "testcode/minitest.mag", "testcode/minitest.gfx"
  end

  test do
    assert_match "ab9ec7787593e310ac4d8187db3f6cee", \
      shell_output("echo Hello | #{bin}/dMagnetic "\
        "-vmode none -vcols 300 -vrows 300 -vecho -sres 1024x768 "\
        "-mag #{share}/games/dMagnetic/minitest.mag "\
        "-gfx #{share}/games/dMagnetic/minitest.gfx "\
        "| md5").strip
  end
end
