class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/v0.8.2.tar.gz"
  sha256 "8691ad36cfa672e7f45f61b44159b949d5eae252d70a921190fc0aee48349587"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8f96191e74ee27bead5296a410276600bd38ba2abed8b80cb0e1f12e5135a7c1" => :catalina
    sha256 "4f1d3a7c45535fac5b3274788c13c4d198058d908cdcd71a4d6c88df91538a3b" => :mojave
    sha256 "566a56f5a6322c7c34f1ae85e991c8bf86244d7923c47eb61b3da626729890fe" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./runtime/cmd/main"
  end

  test do
    (testpath/"hello.cdc").write <<~EOS
      pub fun main(): Int {
        return 0
      }
    EOS
    system "#{bin}/cadence", "hello.cdc"
  end
end
