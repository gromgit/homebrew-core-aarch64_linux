class Xa < Formula
  desc "6502 cross assembler"
  homepage "https://www.floodgap.com/retrotech/xa/"
  url "https://www.floodgap.com/retrotech/xa/dists/xa-2.3.13.tar.gz"
  sha256 "a9477af150b6c8a91cd3d41e1cf8c9df552d383326495576830271ca4467bd86"
  license "GPL-2.0"

  livecheck do
    url :homepage
    regex(/href\s*?=.*?xa[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/xa"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "85909cbfe460ba403109f861cc1403397fb63747240d1766c23d84cfa08b7473"
  end

  def install
    system "make", "CC=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "DESTDIR=#{prefix}",
                   "install"
  end

  test do
    (testpath/"foo.a").write "jsr $ffd2\n"

    system "#{bin}/xa", "foo.a"
    code = File.open("a.o65", "rb") { |f| f.read.unpack("C*") }
    assert_equal [0x20, 0xd2, 0xff], code
  end
end
