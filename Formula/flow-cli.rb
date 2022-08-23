class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v0.39.2.tar.gz"
  sha256 "6afdbf750f254fbd860ba8a9cf527d010ddfeb9570baf6113b4e6646834c8edf"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6451368002233e403d7f0f83c7fbd23d1fab81ccdb2b99223ad06552895c7fa7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b2b4c63e149842af0c355b12bfc366bc9b79c6589f4b95ca9dfd02a2a0627b6e"
    sha256 cellar: :any_skip_relocation, monterey:       "ad0fb6b337174741ff981afb041cbd57a2feb922ffb3bea70789416d3419494e"
    sha256 cellar: :any_skip_relocation, big_sur:        "1e99378a30ded3663ccc9befa415c1ce5504ef3bf7184158d801ce81de9a7716"
    sha256 cellar: :any_skip_relocation, catalina:       "eb469aed92ce4844b6741e75f4ddade4f562ff4f2fe9cf6cd897a4d74113fd5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a377d5d0ba4e9c62f2c4d21d003c4d48caba28beb6e9bf21d63c1d00b425356"
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
