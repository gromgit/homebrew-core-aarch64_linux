class Bcrypt < Formula
  desc "Cross platform file encryption utility using blowfish"
  homepage "https://bcrypt.sourceforge.io/"
  url "https://bcrypt.sourceforge.io/bcrypt-1.1.tar.gz"
  sha256 "b9c1a7c0996a305465135b90123b0c63adbb5fa7c47a24b3f347deb2696d417d"
  license "BSD-3-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?bcrypt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/bcrypt"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "16244e4533eb8fe2d6c7bcd79c38e4ee0c3f63e6a48eb45171179e9f2f0e1c78"
  end

  uses_from_macos "zlib"

  def install
    system "make", "CC=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "LDFLAGS=-lz"
    bin.install "bcrypt"
    man1.install gzip("bcrypt.1")
  end

  test do
    (testpath/"test.txt").write("Hello World!")
    pipe_output("#{bin}/bcrypt -r test.txt", "12345678\n12345678\n")
    mv "test.txt.bfe", "test.out.txt.bfe"
    pipe_output("#{bin}/bcrypt -r test.out.txt.bfe", "12345678\n")
    assert_equal File.read("test.txt"), File.read("test.out.txt")
  end
end
