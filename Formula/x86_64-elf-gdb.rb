class X8664ElfGdb < Formula
  desc "GNU debugger for i386-elf cross development"
  homepage "https://www.gnu.org/software/gdb/"
  url "https://ftp.gnu.org/gnu/gdb/gdb-9.2.tar.xz"
  sha256 "360cd7ae79b776988e89d8f9a01c985d0b1fa21c767a4295e5f88cb49175c555"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 "d2355fbe70719b02b830f2c3522c8b41ff4e95cd1242b31250004c0f76d1e363" => :catalina
    sha256 "fb7e178d35f25670759ee6c1d9467779efb0f942b638e2e9b76dfa0ec227a4ab" => :mojave
    sha256 "36e4d6e182b2d62c4848d424be5dd3f88895e11e457acdca56c37f2622ef2c54" => :high_sierra
  end

  depends_on "python@3.9"
  depends_on "xz"

  conflicts_with "gdb", because: "both install include/gdb, share/gdb and share/info"
  conflicts_with "i386-elf-gdb", because: "both install include/gdb, share/gdb and share/info"

  # Fix for Python 3.9, remove in next version
  # https://sourceware.org/pipermail/gdb-patches/2020-May/169110.html
  patch do
    url "https://github.com/Homebrew/formula-patches/raw/88f56f8f/gdb/python39.diff"
    sha256 "19e989104f54c09a30f06aac87e31706f109784d3e0fdc7ff0fd1bcfd261ebee"
  end

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
