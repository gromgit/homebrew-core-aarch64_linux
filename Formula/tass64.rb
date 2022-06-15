class Tass64 < Formula
  desc "Multi pass optimizing macro assembler for the 65xx series of processors"
  homepage "https://tass64.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/tass64/source/64tass-1.56.2625-src.zip"
  sha256 "c4e570c717c9500f3af61a3ad5d536f22415e2b29ed1eb09b1a955d310c9f3d3"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.0-or-later", "LGPL-2.1-only", "MIT"]

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/tass64"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "94e0e62184e1604895b6f3050214824eeded23452e43b73825c7ee186c9c7196"
  end

  def install
    system "make", "install", "CPPFLAGS=-D_XOPEN_SOURCE", "prefix=#{prefix}"

    # `make install` does not install syntax highlighting definitions
    pkgshare.install "syntax"
  end

  test do
    (testpath/"hello.asm").write <<~'EOS'
      ;; Simple "Hello World" program for C64
      *=$c000
        LDY #$00
      L0
        LDA L1,Y
        CMP #0
        BEQ L2
        JSR $FFD2
        INY
        JMP L0
      L1
        .text "HELLO WORLD",0
      L2
        RTS
    EOS

    system "#{bin}/64tass", "-a", "hello.asm", "-o", "hello.prg"
    assert_predicate testpath/"hello.prg", :exist?
  end
end
