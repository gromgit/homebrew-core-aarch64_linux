class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v0.41.0.tar.gz"
  sha256 "475538f6c3a16e5ce0cc2eebaee7609f85a096d0e92ba42b4493c32933fbcf2c"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0668e87bee42509cce9ff50f7a5621f2b44533ed701e09411dad7239ec3ac6a3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "844cfa73fa9e4993841ad54efa69a3efeaabf7362246a3f020b85c2eaf97edd1"
    sha256 cellar: :any_skip_relocation, monterey:       "92e466a58127006ea4408bd89f9c7cfa050e7761610c28ceb3818a0481bdde41"
    sha256 cellar: :any_skip_relocation, big_sur:        "c6df4a6384a6574b73304e03c92cfa4aabb8a612923b45fa8ab361be523ffc9d"
    sha256 cellar: :any_skip_relocation, catalina:       "fa82ba3ca2f54503bce7eccba8c18ad7525ed9b3e2e049f2a508ac2f5e818c26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0172533695876c976245cdacbf209f365cf30cc986da110b4e58206b65bdd39f"
  end

  depends_on "go" => :build

  def install
    system "make", "cmd/flow/flow", "VERSION=v#{version}"
    bin.install "cmd/flow/flow"

    generate_completions_from_executable(bin/"flow", "completion", base_name: "flow")
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
