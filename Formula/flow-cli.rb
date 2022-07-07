class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v0.37.3.tar.gz"
  sha256 "6be11c6605a3ac2e8b0214d221d74f0a04f1e552e6c94741b661bf53dc8fef0f"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7a8f1b3e1ab064249949e96a4ce140ecc040a2356cdd14af0fbab1ad8cb11c6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5e4a38cd2a8c03a8195b9792c29a7b5b67d2d99d7ce92bf7a9a628dd205591ac"
    sha256 cellar: :any_skip_relocation, monterey:       "0e29fc7ec9e9e6a6f0db5153e8c7b1455e1882041de2e62815ff64bbd96f75c6"
    sha256 cellar: :any_skip_relocation, big_sur:        "05aa9f6c4963b83402f6b1d5213f392b8503151b72aece3eb1639016f8bb144e"
    sha256 cellar: :any_skip_relocation, catalina:       "ca34df769308554df0abf9472eef0cff9c2a22e0f264befa11d61c5527b14540"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b898ce6b6da2f998db78ad85278773cb5e51a950d80f9798af6a498d05d14dff"
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
