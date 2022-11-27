class Peg < Formula
  desc "Program to perform pattern matching on text"
  homepage "https://www.piumarta.com/software/peg/"
  url "https://www.piumarta.com/software/peg/peg-0.1.18.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/p/peg/peg_0.1.18.orig.tar.gz"
  sha256 "20193bdd673fc7487a38937e297fff08aa73751b633a086ac28c3b34890f9084"
  license "MIT"

  livecheck do
    url :homepage
    regex(/href=.*?peg[._-]v?(\d+(?:\.\d+)+)(?:\.orig)?\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/peg"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "5b0ec16b6850bde993262b762d824a6596fa78cff692e04922b1d05fbb84c866"
  end

  def install
    system "make", "all"
    bin.install %w[peg leg]
    man1.install gzip("src/peg.1")
  end

  test do
    (testpath/"username.peg").write <<~EOS
      start <- "username"
    EOS

    system "#{bin}/peg", "-o", "username.c", "username.peg"

    assert_match 'yymatchString(yy, "username")', File.read("username.c")
  end
end
