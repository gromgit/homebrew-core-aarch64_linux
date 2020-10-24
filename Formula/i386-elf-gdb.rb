class I386ElfGdb < Formula
  desc "GNU debugger for i386-elf cross development"
  homepage "https://www.gnu.org/software/gdb/"
  url "https://ftp.gnu.org/gnu/gdb/gdb-10.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/gdb/gdb-10.1.tar.xz"
  sha256 "f82f1eceeec14a3afa2de8d9b0d3c91d5a3820e23e0a01bbb70ef9f0276b62c0"
  license "GPL-3.0-or-later"
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
