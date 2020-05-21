class Csvq < Formula
  desc "SQL-like query language for csv"
  homepage "https://mithrandie.github.io/csvq"
  url "https://github.com/mithrandie/csvq/archive/v1.13.0.tar.gz"
  sha256 "502113fbee735cfd6cc0d9370028b6bef3a4e7e70bd91dff101315bef8c82261"

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
