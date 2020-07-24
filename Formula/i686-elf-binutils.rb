class I686ElfBinutils < Formula
  desc "GNU Binutils for i686-elf cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.35.tar.gz"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.35.tar.gz"
  sha256 "a3ac62bae4f339855b5449cfa9b49df90c635adbd67ecb8a0e7f3ae86a058da6"
  license "GPL-2.0"

  bottle do
    sha256 "c2d082bc08ccb4ce1c870a3e670670eb756f0da433c9a29246277d42814263c1" => :catalina
    sha256 "eb5d102d5ed4cff2710d084d80a3ecba884d39364b7616df9944788090e517e7" => :mojave
    sha256 "7b6014e9338df52a85c747915bafe09af2abba4d9688ac19dc3de73958e4bcde" => :high_sierra
  end

  def install
    system "./configure", "--target=i686-elf",
                          "--prefix=#{prefix}",
                          "--infodir=#{info}/i686-elf-binutils",
                          "--disable-nls"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test-s.s").write <<~EOS
      .section .data
      .section .text
      .globl _start
      _start:
          movl $1, %eax
          movl $4, %ebx
          int $0x80
    EOS
    system "#{bin}/i686-elf-as", "--32", "-o", "test-s.o", "test-s.s"
    assert_match "file format elf32-i386",
      shell_output("#{bin}/i686-elf-objdump -a test-s.o")
  end
end
