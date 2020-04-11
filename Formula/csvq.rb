class Csvq < Formula
  desc "SQL-like query language for csv"
  homepage "https://mithrandie.github.io/csvq"
  url "https://github.com/mithrandie/csvq/archive/v1.12.5.tar.gz"
  sha256 "dfe2cc1b0eb74faeb71490b186270b6d963181d37fa38278125d1078e94f5d3d"

  bottle do
    cellar :any_skip_relocation
    sha256 "0001aadb1c6305299146d825b0969a2d48778ee1bc95e9f6d01c0924cf64fcad" => :catalina
    sha256 "f4fdf84d80bffbf85a31592925018f2730526ceb052731f3699e6be3a74b4ab7" => :mojave
    sha256 "07585255d50b4fd7b2f90ae8405f57bc239f676adc452a4a409fd22c2265efb6" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "make"
    bin.install "csvq"
  end

  test do
    system "#{bin}/csvq", "--version"

    (testpath/"test.csv").write <<~EOS
      a,b,c
      1,2,3
    EOS
    expected = <<~EOS
      a,b
      1,2
    EOS
    result = shell_output("#{bin}/csvq --format csv 'SELECT a, b FROM `test.csv`'")
    assert_equal expected, result
  end
end
