class Csvq < Formula
  desc "SQL-like query language for csv"
  homepage "https://mithrandie.github.io/csvq"
  url "https://github.com/mithrandie/csvq/archive/v1.11.7.tar.gz"
  sha256 "684e864c3dea0c6620b7764ef9e737b85215ffc22214aa4abbd96217ea383b0d"

  bottle do
    cellar :any_skip_relocation
    sha256 "47eac248049d1b9fb603b2bc8f6c5354fa3c123f0e65319d0575918ee5ab69ad" => :catalina
    sha256 "432595eaff75550a2a728f1353795a7f77da980420fe63fcca8df2cf22588e89" => :mojave
    sha256 "27af461626136c7bbc5a7e4e6a0cd3718e65d29abd93ef2f10ed725f4ff577b2" => :high_sierra
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
