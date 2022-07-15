class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v0.37.5.tar.gz"
  sha256 "40b3196163f44848859df204019b9d7231ea94504e2c1a52677405cd47242d7e"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "60e7c4922bfb0046e8cb96a0aaa99a0303376572efbeda08b3216ad39777c525"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d8803687f048ee0e9535c88dde9dcd81ce63ae397eab63dc13a56b36d8b70029"
    sha256 cellar: :any_skip_relocation, monterey:       "8d388b15ef8b1581d6ca6f300e9df4889935813506bd794c2128c786f261ae25"
    sha256 cellar: :any_skip_relocation, big_sur:        "7361f67f91cdf9f58df761199e69276c1b90ebe9d5f7884d6957952868cc68fc"
    sha256 cellar: :any_skip_relocation, catalina:       "a93321dc435eacb6206466f2c4ff127c642a2930e0c5d5a4f3ce519caf806dc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cbf6d4f2fa7155dc58ff90547adc5ccb08bf6b663f0e114aa00badcd250adc0c"
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
