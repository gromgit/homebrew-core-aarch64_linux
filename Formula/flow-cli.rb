class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v0.37.6.tar.gz"
  sha256 "bb289d43358eab03896fee95517e324a6cda103fec7b49256d99d6f733d6fe4a"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "12c26585f0a510fe8a6207dfcf0c6f40d79ad94223b2c1316611bd37e7c7fb9c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1d22f8ef00093cf49da484ae0a8b90b34fb8cbfef6d3319ab327c7aa44aeb30a"
    sha256 cellar: :any_skip_relocation, monterey:       "7ae8438af8d82574edec58adb0368219ca1e9fd2145d03cb5e00243bd15d8a7f"
    sha256 cellar: :any_skip_relocation, big_sur:        "704cfc84ada2801b8c4c69507a0c78b81fc1021b1efbcc7bf4f39c833848daff"
    sha256 cellar: :any_skip_relocation, catalina:       "df567c114927aaa09000a4bce2d96aeb8cd7284b163514c8976d52d6106818f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a21fba5cf28c659369f8c872ad3cda4728fe4e4c480bb39d275c7c7e246b31ec"
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
