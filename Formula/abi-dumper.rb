class AbiDumper < Formula
  desc "Dump ABI of an ELF object containing DWARF debug info"
  homepage "https://github.com/lvc/abi-dumper"
  url "https://github.com/lvc/abi-dumper/archive/refs/tags/1.2.tar.gz"
  sha256 "8a9858c91b4e9222c89b676d59422053ad560fa005a39443053568049bd4d27e"
  license "LGPL-2.1-or-later"
  head "https://github.com/lvc/abi-dumper.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/abi-dumper"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "07bd02c972eb9f7c60ff957c83ae709dd81ebc8420f2ba900a7b9dc141f5d80b"
  end

  depends_on "abi-compliance-checker"
  depends_on "elfutils"
  depends_on :linux
  depends_on "universal-ctags"
  depends_on "vtable-dumper"

  def install
    # We pass `--program-prefix=elfutils-` when building `elfutils`.
    inreplace "abi-dumper.pl", "eu-readelf", "elfutils-readelf"
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    testlib = testpath/shared_library("libtest")
    (testpath/"test.c").write "int foo() { return 0; }"
    system ENV.cc, "-g", "-Og", "-shared", "test.c", "-o", testlib
    system bin/"abi-dumper", testlib, "-o", "test.dump"
    assert_predicate testpath/"test.dump", :exist?
  end
end
