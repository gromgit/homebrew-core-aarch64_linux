class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v0.37.2.tar.gz"
  sha256 "7b973f31d05b4acfadd9908656f2e22924b1e9cf8ffd7973e2d58b573793f9ae"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd4f219671c81337cad7dff789a942f294da89fab6c16cdc4158fadf043a6e94"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "934d8ad8ffe39c6b6ad985ae21a7236b66df56050eab5cf4e7e35ae469d5c756"
    sha256 cellar: :any_skip_relocation, monterey:       "dc097b26dc36dc36cb93b64f47b0387dc27a30040e96d10c5acab230892b91a1"
    sha256 cellar: :any_skip_relocation, big_sur:        "b17a5e3561a13fc3fde773b19fb8286839115d8706428643a5ff1e82818b367e"
    sha256 cellar: :any_skip_relocation, catalina:       "f20063a204f34845c54142a995fcb3df849f49c8a55bae40ad20f618c51eef69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "635759e0583cb12f5d9829c5cb1740ba035d4a2ab3422e9a1882cadccba25309"
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
