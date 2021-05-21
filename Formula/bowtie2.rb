class Bowtie2 < Formula
  desc "Fast and sensitive gapped read aligner"
  homepage "https://bowtie-bio.sourceforge.io/bowtie2/"
  url "https://github.com/BenLangmead/bowtie2/archive/v2.4.3.tar.gz"
  sha256 "616017bcc68fc178418575fe39ffde42fff811d0d071bac7b1e7650288e4d166"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "42595bf08b477aef727f3e83bf8f8e8ad3c8d9818b487598aa702e98e0cfb193"
    sha256 cellar: :any_skip_relocation, catalina: "03fd56e55cbb1807176aca27e8e1924faf762e9d17c0b7362baf27de0fa72c3f"
    sha256 cellar: :any_skip_relocation, mojave:   "95e10e1d2250a9d228fec785a3b331b3357fd497b6c181a953746be868c20b89"
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
