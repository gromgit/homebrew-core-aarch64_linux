class X8664ElfGdb < Formula
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
    sha256 "d2355fbe70719b02b830f2c3522c8b41ff4e95cd1242b31250004c0f76d1e363" => :catalina
    sha256 "fb7e178d35f25670759ee6c1d9467779efb0f942b638e2e9b76dfa0ec227a4ab" => :mojave
    sha256 "36e4d6e182b2d62c4848d424be5dd3f88895e11e457acdca56c37f2622ef2c54" => :high_sierra
  end

  depends_on "python@3.9"
  depends_on "xz"

  conflicts_with "gdb", because: "both install include/gdb, share/gdb and share/info"
  conflicts_with "i386-elf-gdb", because: "both install include/gdb, share/gdb and share/info"

  def install
    args = %W[
      --target=x86_64-elf
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

      system "make", "install-gdb"
    end
  end

  test do
    system "#{bin}/x86_64-elf-gdb", "#{bin}/x86_64-elf-gdb", "-configuration"
  end
end
