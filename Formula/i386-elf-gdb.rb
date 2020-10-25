class I386ElfGdb < Formula
  desc "GNU debugger for i386-elf cross development"
  homepage "https://www.gnu.org/software/gdb/"
  url "https://ftp.gnu.org/gnu/gdb/gdb-9.2.tar.xz"
  mirror "https://ftpmirror.gnu.org/gdb/gdb-9.2.tar.xz"
  sha256 "360cd7ae79b776988e89d8f9a01c985d0b1fa21c767a4295e5f88cb49175c555"
  license "GPL-2.0"
  revision 1
  head "https://sourceware.org/git/binutils-gdb.git"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "b43c93bf06ff777d8f98a283d2b17f2ad6f99a290fada81ba66c7afc1ad398f5" => :catalina
    sha256 "1f1c96fa5d20f0c66a21cce01fa0732c5ea37861acaecfb7b0a21f931e1099f7" => :mojave
    sha256 "7a9834dccac84a18afe4dc897fa7ff77248098844cbce868abdae9ecaf9fc39e" => :high_sierra
  end

  depends_on "python@3.9"
  depends_on "xz" # required for lzma support

  conflicts_with "gdb", because: "both install include/gdb, share/gdb and share/info"
  conflicts_with "x86_64-elf-gdb", because: "both install include/gdb, share/gdb and share/info"

  # Fix for Python 3.9, remove in next version
  # https://sourceware.org/pipermail/gdb-patches/2020-May/169110.html
  patch do
    url "https://github.com/Homebrew/formula-patches/raw/88f56f8f/gdb/python39.diff"
    sha256 "19e989104f54c09a30f06aac87e31706f109784d3e0fdc7ff0fd1bcfd261ebee"
  end

  def install
    args = %W[
      --target=i386-elf
      --prefix=#{prefix}
      --disable-debug
      --disable-dependency-tracking
      --with-lzma
      --with-python=#{Formula["python@3.9"].opt_bin}/python3
      --disable-binutils
    ]

    mkdir "build" do
      system "../configure", *args
      system "make"

      # Don't install bfd or opcodes, as they are provided by binutils
      system "make", "install-gdb"
    end
  end

  test do
    system "#{bin}/i386-elf-gdb", "#{bin}/i386-elf-gdb", "-configuration"
  end
end
