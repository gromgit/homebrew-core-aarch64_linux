class Libkeccak < Formula
  desc "Keccak-family hashing library"
  homepage "https://github.com/maandree/libkeccak"
  url "https://github.com/maandree/libkeccak/archive/1.3.1.2.tar.gz"
  sha256 "c17df59e038f9f1b0f09aa79944ba572f5c4efcbfe8bc6bc7aae1b40f035abe9"
  license "ISC"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/libkeccak"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "62ef4c5a45aba64308ef969c12d17fcb9228b02dc0a6aea79890e735af292398"
  end

  def install
    args = ["PREFIX=#{prefix}"]
    args << "OSCONFIGFILE=macos.mk" if OS.mac?

    system "make", "install", *args
    pkgshare.install %w[.testfile test.c]
  end

  test do
    cp_r pkgshare/".testfile", testpath
    system ENV.cc, pkgshare/"test.c", "-std=c99", "-O3", "-I#{include}", "-L#{lib}", "-lkeccak", "-o", "test"
    system "./test"
  end
end
