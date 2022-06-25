class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/v0.24.6.tar.gz"
  sha256 "a488233735bbcf39f7ac41d53cfb79aa5399af7fd958d853a0bc85332a21e283"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b52a5d464f0701acc1205e592fdace2efa40d3625572d6f96e1bc3eb72161ed"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9ddce1849f39c38bc4df1ac9b363cf7ec98039b796d4f4529746982745abd236"
    sha256 cellar: :any_skip_relocation, monterey:       "93f69ca1fa3f2262d89b0b3402463dd89ee04508ddc9fd455d7a8c78794398a4"
    sha256 cellar: :any_skip_relocation, big_sur:        "d1b9f2071a6e0c28b948e10db91f254666d2a11bf4f39304e721c956cf346f34"
    sha256 cellar: :any_skip_relocation, catalina:       "66bb794f0f439102f569b118a133cc2165d15fae4f9bc0a43dcac7e5a174af21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e204e78f5ef8e2e976ed80516d92f01686682ae81c97e8955ab756a739ac6a87"
  end

  depends_on "go" => :build

  conflicts_with "cadence-workflow", because: "both install a `cadence` executable"

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
