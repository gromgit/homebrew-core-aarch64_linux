class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v0.37.4.tar.gz"
  sha256 "f41f96f803b98550f9f0a7c8114ecd68ce97c9fee0e1da119ea56b539f93e496"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a40005cfa121cecd4b6ebcd0d73adbb914b07b8f438a052883fffa432f4a87c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0e105d7fc7934058e58e546661a53351ae6b44936312f1ac4a69bb3ebc01f88e"
    sha256 cellar: :any_skip_relocation, monterey:       "f24fbef70628ee461e8f3bcc68ff7794fc71c1fd4b60fcb45ce9de1ea500f795"
    sha256 cellar: :any_skip_relocation, big_sur:        "f0f1aff79cd5143019cb27cce06d882b317f33bce1c628f794571f4c88ee1365"
    sha256 cellar: :any_skip_relocation, catalina:       "30818ef7218ac46689fcbdddadfbdd5da0e0301799e14762675674a44e5bac01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "823486751334e6b614dbb7164b0b1ae47f7ca8dbf81c93900710d352de2e4583"
  end

  depends_on "go" => :build

  def install
    system "make", "cmd/flow/flow", "VERSION=v#{version}"
    bin.install "cmd/flow/flow"
  end

  test do
    (testpath/"hello.cdc").write <<~EOS
      pub fun main() {
        log("Hello, world!")
      }
    EOS
    system "#{bin}/flow", "cadence", "hello.cdc"
  end
end
