class Bowtie2 < Formula
  desc "Fast and sensitive gapped read aligner"
  homepage "https://bowtie-bio.sourceforge.io/bowtie2/"
  url "https://github.com/BenLangmead/bowtie2/archive/v2.4.2.tar.gz"
  sha256 "ea33a1562faf759b21b3a905e20b87a3524ac4e53af8cd723d9a9f31ee159c8a"
  license "GPL-3.0"

  bottle do
    cellar :any
    sha256 "fd107ab602165eac36dc748124cc6688f8eccf63ff9a64ebcf82fa4db45b5788" => :catalina
    sha256 "ca70730942c77835fc3ee267dd6c284d51351af0f59db282876ca9ada2ce4672" => :mojave
    sha256 "61597b46c1e6bd55d74c89e107342c4bdb5014d3a7ea37628d544b6f429bef9c" => :high_sierra
  end

  depends_on "tbb"

  def install
    system "make", "install", "PREFIX=#{prefix}"
    pkgshare.install "example", "scripts"
  end

  test do
    system "#{bin}/bowtie2-build",
           "#{pkgshare}/example/reference/lambda_virus.fa", "lambda_virus"
    assert_predicate testpath/"lambda_virus.1.bt2", :exist?,
                     "Failed to create viral alignment lambda_virus.1.bt2"
  end
end
