class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v0.39.1.tar.gz"
  sha256 "75da9609ed4527a6ec22b0add666b74262cf2b7d697aebc162309be8f84911de"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc67ae154a8e04fb40c85b8fd24bc5a3bd55bea0628b077696180d927c6f4070"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "769e5fb5cec40828db4cb4b4fab015ae1bc1849ec8b4810cd68f5d49e5f123fe"
    sha256 cellar: :any_skip_relocation, monterey:       "18e67e19b151f0da7dacb85367b4f63024d628ea5a4090352aff3e71833c66c4"
    sha256 cellar: :any_skip_relocation, big_sur:        "2138b01ae96c7dd8395f35ff78fa34ebde6b3f51f18e03b57367c0ea5645c336"
    sha256 cellar: :any_skip_relocation, catalina:       "554f58736e8dd44cd49992d30003727258bba92f3b9a7b3424adca76ed6cb141"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ae68fd56cb0decde97a9881480387bbc8594df34fa3374b032f27677deb5f6a"
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
