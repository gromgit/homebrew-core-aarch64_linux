class Dmagnetic < Formula
  desc "Magnetic Scrolls Interpreter"
  homepage "https://www.dettus.net/dMagnetic/"
  url "https://www.dettus.net/dMagnetic/dMagnetic_0.32.tar.bz2"
  sha256 "9671b863cbb126e122923fa974806ff0e998af471c98e878c1392c20a3606206"
  license "BSD-2-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?dMagnetic[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "cf25009d9eff9196c36d27402aebae7e7ecf90a5a8029162ec6f33d6457ce9ed"
    sha256 cellar: :any_skip_relocation, big_sur:       "5e7d9d39d36fbeb673598c7974ee8dbf6fc542ea00e73eeed6253db6c0fc67bf"
    sha256 cellar: :any_skip_relocation, catalina:      "f83ef8d3c11c5d64095de0e634155e3f19a42ca32b13da4bfeb9956e9ee30c5f"
    sha256 cellar: :any_skip_relocation, mojave:        "0ad1e3399a09a71dbd26744250bddf5468403e1db84057406e52b35ab4b374e4"
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
