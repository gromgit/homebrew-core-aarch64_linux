class Dmagnetic < Formula
  desc "Magnetic Scrolls Interpreter"
  homepage "https://www.dettus.net/dMagnetic/"
  url "https://www.dettus.net/dMagnetic/dMagnetic_0.27.tar.bz2"
  sha256 "ed6be4e1e3f1dd09dcf2b73ccd2ddd4c7630f4755b25883b38b2e99768559375"
  license "BSD-2-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "5e7cc2cd1e773b273acbc10bf8ab40b398a56e2a95e4c47981bc4ec5181d1525" => :big_sur
    sha256 "781fbe7020403897458658ee63c4854bc17fcd947750343c5806f4f275b56fec" => :catalina
    sha256 "d6a8d0fbb621e7c582aefa8565e278388c8cd4a893e6d9d35a881c5abb42d9bd" => :mojave
    sha256 "9cde03055d52999bccc3266762deada55191f4f73481cd64bce91377e7490ec6" => :high_sierra
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
