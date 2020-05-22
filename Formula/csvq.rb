class Csvq < Formula
  desc "SQL-like query language for csv"
  homepage "https://mithrandie.github.io/csvq"
  url "https://github.com/mithrandie/csvq/archive/v1.13.1.tar.gz"
  sha256 "02c480764f4d87217de3b3f068feee6f9ad08ee6f72b563fe0189ef90a1735cc"

  bottle do
    cellar :any_skip_relocation
    sha256 "a5be89a4ef53805b656ca5a5a320a696349f04e3cebb01c91bf1d7c423346d7f" => :catalina
    sha256 "66010f8a707a8d791645a654498d3486b2990f698693d98b1b9d348d7ba23bb7" => :mojave
    sha256 "88bb8a3ff0aba6f931e3cd7adebc5a5c15153deabdf8c7704a83fb55353758b9" => :high_sierra
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
