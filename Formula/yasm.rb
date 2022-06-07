class Yasm < Formula
  desc "Modular BSD reimplementation of NASM"
  homepage "https://yasm.tortall.net/"
  url "https://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz"
  mirror "https://ftp.openbsd.org/pub/OpenBSD/distfiles/yasm-1.3.0.tar.gz"
  sha256 "3dce6601b495f5b3d45b59f7d2492a340ee7e84b5beca17e48f862502bd5603f"
  revision 2

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/yasm"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "c04b280840f14b547291f4178c4d1919bd94baf35e2e286531dcb982e9d33ecb"
  end

  head do
    url "https://github.com/yasm/yasm.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext"
  end

  def install
    args = %W[
      --disable-debug
      --prefix=#{prefix}
      --disable-python
    ]

    # https://github.com/Homebrew/legacy-homebrew/pull/19593
    ENV.deparallelize

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"foo.s").write <<~EOS
      mov eax, 0
      mov ebx, 0
      int 0x80
    EOS
    system "#{bin}/yasm", "foo.s"
    code = File.open("foo", "rb") { |f| f.read.unpack("C*") }
    expected = [0x66, 0xb8, 0x00, 0x00, 0x00, 0x00, 0x66, 0xbb,
                0x00, 0x00, 0x00, 0x00, 0xcd, 0x80]
    assert_equal expected, code

    if OS.mac?
      (testpath/"test.asm").write <<~EOS
        global start
        section .text
        start:
            mov     rax, 0x2000004 ; write
            mov     rdi, 1 ; stdout
            mov     rsi, qword msg
            mov     rdx, msg.len
            syscall
            mov     rax, 0x2000001 ; exit
            mov     rdi, 0
            syscall
        section .data
        msg:    db      "Hello, world!", 10
        .len:   equ     $ - msg
      EOS
      system "#{bin}/yasm", "-f", "macho64", "test.asm"
      system "/usr/bin/ld", "-macosx_version_min", "10.8.0", "-static", "-o", "test", "test.o"
    else
      (testpath/"test.asm").write <<~EOS
        global _start
        section .text
        _start:
            mov     rax, 1
            mov     rdi, 1
            mov     rsi, msg
            mov     rdx, msg.len
            syscall
            mov     rax, 60
            mov     rdi, 0
            syscall
        section .data
        msg:    db      "Hello, world!", 10
        .len:   equ     $ - msg
      EOS
      system "#{bin}/yasm", "-f", "elf64", "test.asm"
      system "/usr/bin/ld", "-static", "-o", "test", "test.o"
    end
    assert_equal "Hello, world!\n", shell_output("./test")
  end
end
