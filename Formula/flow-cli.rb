class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v0.39.0.tar.gz"
  sha256 "818e42be325a0c969d41a0c2828b1dc1567b53ac164e3f294b5b009dedb68019"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "891c02402533c65b54f6c417777bdce6c867bc2f33759a150e6e43b5f1083ae0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9ab6be20913a549e3994b1f1d5cd9b5f0dfc5f7a2e1e8823b847cfee8074dcfb"
    sha256 cellar: :any_skip_relocation, monterey:       "32010c2fa542e97d6872f5b0dfa2ae59c78f680c9b1083b03206754438026f46"
    sha256 cellar: :any_skip_relocation, big_sur:        "b2aa6c6e3badb009691b8614ae8747c3de88c51129f80c4d017ad774eeb9cd88"
    sha256 cellar: :any_skip_relocation, catalina:       "bbbea6b0546409ba1d93942fcc25e765f95812a51fcb93e0c3a201c88bec9a0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9c105da37c61373740af45875101b3a7a0c310eaa80b1abd7c75fd0bdf30bfb"
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
