class Gdb < Formula
  desc "GNU debugger"
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
    sha256 "1423f4be295c421835b9da9af107b24eb898ad9a109d7386d46ca3d75765992b" => :catalina
    sha256 "628a0639add17870b589dd586aa683c85c8090ba8d4abcb954d04e0051444181" => :mojave
    sha256 "f159ff299b9bd7fc5aec573b5bbf4bb13036decf2eb9a16db1096f9073838828" => :high_sierra
  end

  depends_on "python@3.9"
  depends_on "xz" # required for lzma support

  uses_from_macos "expat"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "guile"
  end

  conflicts_with "i386-elf-gdb", because: "both install include/gdb, share/gdb and share/info"
  conflicts_with "x86_64-elf-gdb", because: "both install include/gdb, share/gdb and share/info"

  fails_with :clang do
    build 800
    cause <<~EOS
      probe.c:63:28: error: default initialization of an object of const type
      'const any_static_probe_ops' without a user-provided default constructor
    EOS
  end

  def install
    args = %W[
      --enable-targets=all
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

  def caveats
    <<~EOS
      gdb requires special privileges to access Mach ports.
      You will need to codesign the binary. For instructions, see:

        https://sourceware.org/gdb/wiki/BuildingOnDarwin

      On 10.12 (Sierra) or later with SIP, you need to run this:

        echo "set startup-with-shell off" >> ~/.gdbinit
    EOS
  end

  test do
    system bin/"gdb", bin/"gdb", "-configuration"
  end
end
