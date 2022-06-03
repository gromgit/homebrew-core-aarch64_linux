class Tendermint < Formula
  desc "BFT state machine replication for applications in any programming languages"
  homepage "https://tendermint.com/"
  url "https://github.com/tendermint/tendermint/archive/v0.35.6.tar.gz"
  sha256 "95de8d59c7a5eee5dc6fddc76e0eb68a9c649a92e54559ec73851b41e381f58d"
  license "Apache-2.0"
  head "https://github.com/tendermint/tendermint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e3df8edb89f6f5286cdf1f59ce3fa8e9d300005980c69f682547a0ed050fd38f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e3df8edb89f6f5286cdf1f59ce3fa8e9d300005980c69f682547a0ed050fd38f"
    sha256 cellar: :any_skip_relocation, monterey:       "915530928787b572378bc9542649829c0fba0b5fa7c7e5da4ddbcb2fd38281e6"
    sha256 cellar: :any_skip_relocation, big_sur:        "915530928787b572378bc9542649829c0fba0b5fa7c7e5da4ddbcb2fd38281e6"
    sha256 cellar: :any_skip_relocation, catalina:       "915530928787b572378bc9542649829c0fba0b5fa7c7e5da4ddbcb2fd38281e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c76b2a80d2fd740faab06a75f830e7fd321df9d2802e39099d5f91984b0742c1"
  end

  depends_on "go" => :build

  def install
    system "make", "build", "VERSION=#{version}"
    bin.install "build/tendermint"
  end

  test do
    mkdir(testpath/"staging")
    shell_output("#{bin}/tendermint init full --home #{testpath}/staging")
    assert_predicate testpath/"staging/config/genesis.json", :exist?
    assert_predicate testpath/"staging/config/config.toml", :exist?
    assert_predicate testpath/"staging/data", :exist?
  end
end
