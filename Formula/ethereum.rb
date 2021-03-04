class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://ethereum.github.io/go-ethereum/"
  url "https://github.com/ethereum/go-ethereum/archive/v1.10.0.tar.gz"
  sha256 "c514ade85ac88f146bf64fc9eb876f6f2ffddb8bc0bf0cbd4eb1e913a610aa53"
  license "LGPL-3.0-or-later"
  head "https://github.com/ethereum/go-ethereum.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9210769c0db416007d4c527988ec141b6f8e94df104ee9f5a27c0200e22cc7cf"
    sha256 cellar: :any_skip_relocation, big_sur:       "3b6e9af32e3633328aa807a25be3c7a065dd4469d85d8f5ac8221c2278689a23"
    sha256 cellar: :any_skip_relocation, catalina:      "838dc89173fed12283334907e07357c0b647a94ff7cdeebdb6dcccf3f2a7589d"
    sha256 cellar: :any_skip_relocation, mojave:        "f7c5d947f01046be88a2e93311a5fa09749e3859d42a7cf04eb271064027002e"
  end

  depends_on "go" => :build

  def install
    system "make", "all"
    bin.install Dir["build/bin/*"]
  end

  test do
    (testpath/"genesis.json").write <<~EOS
      {
        "config": {
          "homesteadBlock": 10
        },
        "nonce": "0",
        "difficulty": "0x20000",
        "mixhash": "0x00000000000000000000000000000000000000647572616c65787365646c6578",
        "coinbase": "0x0000000000000000000000000000000000000000",
        "timestamp": "0x00",
        "parentHash": "0x0000000000000000000000000000000000000000000000000000000000000000",
        "extraData": "0x",
        "gasLimit": "0x2FEFD8",
        "alloc": {}
      }
    EOS
    system "#{bin}/geth", "--datadir", "testchain", "init", "genesis.json"
    assert_predicate testpath/"testchain/geth/chaindata/000001.log", :exist?,
                     "Failed to create log file"
  end
end
