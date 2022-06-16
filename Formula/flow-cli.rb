class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v0.36.2.tar.gz"
  sha256 "19eaff46eda642f2551fe524b6591c0ec5630006a817ca3810d09baae9263371"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb8ead88928b6d01f023820c537ee4b6a57acacabe6785a6b6eca84d66ff3da2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "539f915aa638e1edf26824003103d78344b4190190084ace7c563ad52e76869f"
    sha256 cellar: :any_skip_relocation, monterey:       "337173f0bb92c51fae2d0c16e8a6e5283b76285b3101f3c2d2d982b1e1593b95"
    sha256 cellar: :any_skip_relocation, big_sur:        "05743de40430a9e8f5b96a6fe616d3f6cc2c0ddefc5d08fc022480864e48445b"
    sha256 cellar: :any_skip_relocation, catalina:       "c9fba9dcefa8e5a6db39709a41f777e70a798f2822a5d14d7095ae9296422434"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd08a25f7834eb8f13f92e700860ad13f468e4b43eacb372eded2a690e87fb8f"
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
