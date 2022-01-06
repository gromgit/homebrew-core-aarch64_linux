class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://geth.ethereum.org/"
  url "https://github.com/ethereum/go-ethereum/archive/v1.10.15.tar.gz"
  sha256 "0c03bdf88fc01053fee8d73e3acc9579354b8c3c2333b544b800040dcd414963"
  license "LGPL-3.0-or-later"
  head "https://github.com/ethereum/go-ethereum.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f63870eb035fd49b966d2253317e2f110b675784e8bc239f5b2aa79f32ff876d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1e484e5673e4da3f0c8c446c6bc4551395d5f9bf971010e36f70fc58680288e7"
    sha256 cellar: :any_skip_relocation, monterey:       "0a20e97903b3a3998706531d04da333f486278bc3de8c83f97518cbcaa749fbf"
    sha256 cellar: :any_skip_relocation, big_sur:        "48397d764875ce1e5d2cbe23eeb7a3e25ea6de1b4674b68faf692c0d7367ccdb"
    sha256 cellar: :any_skip_relocation, catalina:       "0e481a26cf4313613170bdfdca651170a2e2937845335b05686d540d4564f9f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49edcb5ddc9d0bd89e29bc71da87885bfd6853d81ecbe7107da0af7218e6b1d9"
  end

  depends_on "go" => :build

  def install
    # See https://github.com/golang/go/issues/26487
    ENV.O0 if OS.linux?

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
