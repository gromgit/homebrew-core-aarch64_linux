class Z80dasm < Formula
  desc "Disassembler for the Zilog Z80 microprocessor and compatibles"
  homepage "https://www.tablix.org/~avian/blog/articles/z80dasm/"
  url "https://www.tablix.org/~avian/z80dasm/z80dasm-1.1.6.tar.gz"
  sha256 "76d3967bb028f380a0c4db704a894c2aa939951faa5c5630b3355c327c0bd360"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.tablix.org/~avian/z80dasm/"
    regex(/href=.*?z80dasm[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/z80dasm"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "1ed3c9391d1ae11e909546f71360840ad4ffe6dcc74ac3b5cf1e39bcd96402a0"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    path = testpath/"a.bin"
    path.binwrite [0xcd, 0x34, 0x12].pack("c*")
    assert_match "call 01234h", shell_output("#{bin}/z80dasm #{path}")
  end
end
