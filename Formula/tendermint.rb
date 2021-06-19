class Tendermint < Formula
  desc "BFT state machine replication for applications in any programming languages"
  homepage "https://tendermint.com/"
  url "https://github.com/tendermint/tendermint/archive/v0.34.11.tar.gz"
  sha256 "1bcf8321dbabc1ca988d5c18c8bbc5d7ffadc61b2710880238fd615f4a1bb3d5"
  license "Apache-2.0"
  head "https://github.com/tendermint/tendermint.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0c027d336c0f525b44a6d13062960dfcb54bacafd41086dfd9a0253b8383c97a"
    sha256 cellar: :any_skip_relocation, big_sur:       "2ddede8d19008f331df73781d3efca30409fc1546e6d5c85a93039bcaaec958f"
    sha256 cellar: :any_skip_relocation, catalina:      "2ddede8d19008f331df73781d3efca30409fc1546e6d5c85a93039bcaaec958f"
    sha256 cellar: :any_skip_relocation, mojave:        "2ddede8d19008f331df73781d3efca30409fc1546e6d5c85a93039bcaaec958f"
  end

  depends_on "go" => :build

  def install
    system "make", "build", "VERSION=#{version}"
    bin.install "build/tendermint"
  end

  test do
    mkdir(testpath/"staging")
    shell_output("#{bin}/tendermint init --home #{testpath}/staging")
    assert_predicate testpath/"staging/config/genesis.json", :exist?
    assert_predicate testpath/"staging/config/config.toml", :exist?
    assert_predicate testpath/"staging/data", :exist?
  end
end
