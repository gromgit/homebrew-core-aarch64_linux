class Samtools < Formula
  desc "Tools for manipulating next-generation sequencing data"
  homepage "https://www.htslib.org/"
  url "https://github.com/samtools/samtools/releases/download/1.13/samtools-1.13.tar.bz2"
  sha256 "616ca2e051cc8009a1e9c01cfd8c7caf8b70916ddff66f3b76914079465f8c60"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "90bb0238ac2b339a77305494d4be5413a446cc3f74276215834b4464c5c1e13f"
    sha256 cellar: :any,                 big_sur:       "91e903cb284e1ea536117a1c583ab66d40691251dc23fe2904c43548b0759c9b"
    sha256 cellar: :any,                 catalina:      "1ba9234ba9de00494f56515347be7027161fddd0ae7f44e88db9809cfa9440a2"
    sha256 cellar: :any,                 mojave:        "441bf778fce091ac24cfca18b967b1693e54bea5cd44e217f7427597c8a38271"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c2cd108ce9fc26996ed786b1fb794f86c154aa9fc4c078d9fe25070fe1fdb93"
  end

  depends_on "htslib"

  uses_from_macos "ncurses"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-htslib=#{Formula["htslib"].opt_prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.fasta").write <<~EOS
      >U00096.2:1-70
      AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTCTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC
    EOS
    system bin/"samtools", "faidx", "test.fasta"
    assert_equal "U00096.2:1-70\t70\t15\t70\t71\n", (testpath/"test.fasta.fai").read
  end
end
