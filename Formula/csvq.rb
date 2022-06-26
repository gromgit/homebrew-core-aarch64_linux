class Csvq < Formula
  desc "SQL-like query language for csv"
  homepage "https://mithrandie.github.io/csvq"
  url "https://github.com/mithrandie/csvq/archive/v1.17.5.tar.gz"
  sha256 "6ff04ed951a099fc6aada13c920b8b5bcec1437015cf315dc090293694b5d0ee"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0d5a8c77096cc63db5b7eec835a3f180e885c69cd02482891ec64d2d3da26e6d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "37cfcd121898de093e87a4396346017f4e6bdbc5f06517578b4643c98d43d65c"
    sha256 cellar: :any_skip_relocation, monterey:       "9088fbd86a9f93c672e25b08206a8344cf85612c2b97fcd7c8ea57445f1d4b26"
    sha256 cellar: :any_skip_relocation, big_sur:        "45e75532160a06b9df87677bc38a0edeef069c9e0e30d9ed70f642dffe678e85"
    sha256 cellar: :any_skip_relocation, catalina:       "574b9812badc98c109f98e4659c21a62acadb630d6a803bac078c0aa273f1148"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6585d630184aaf0242cfa66cab9e139d698ce41bc69c1be13f8e6391bff3ce6e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
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
