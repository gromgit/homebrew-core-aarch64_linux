class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://geth.ethereum.org/"
  url "https://github.com/ethereum/go-ethereum/archive/v1.10.21.tar.gz"
  sha256 "423c1cdd54033b9b12169977e6013d76088ba813fff8cc20d5f37ce817b0fff8"
  license "LGPL-3.0-or-later"
  head "https://github.com/ethereum/go-ethereum.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "131e8093ede2f9451ec6e45ab3df4d1db4b385ef55b88e51f15c18610a53abc5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8c9067088386c3c2822789f38802011141b7f0ec241d9b2e8a8507cb47888cf3"
    sha256 cellar: :any_skip_relocation, monterey:       "238653edd9dcd23f34a358ee233ec26af0431128445640e5521df132683e6e83"
    sha256 cellar: :any_skip_relocation, big_sur:        "64c7f9597eed074606807aa7098c0a2a4b7f6c12aa3b55124dbabd8c3166a9cb"
    sha256 cellar: :any_skip_relocation, catalina:       "099767d148add0c71b3cd0660ad17166f803e2093d92f30020da1c42fbd0c544"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f62fd71d893c299c4e703248947e7e6fcab1eb68c88a978a42515e3cc411a10b"
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
