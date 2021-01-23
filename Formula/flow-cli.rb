class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v0.13.2.tar.gz"
  sha256 "65d9e2451e667c8466a4267cfbe75ab7ebb77b20549e59dfc4eef82b89812ba6"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d0efaa85dadbb105dbeaf6d56ec0c3eef4e3fa3743d843723c72b066dd7678a4" => :big_sur
    sha256 "d2336ea4c8453b551ca63f1fc32f5bb21a885444a46abc146d2c0d53f4bdb992" => :arm64_big_sur
    sha256 "fe0c5e3b0ae07655e0dd78ac52ce71654a8e68492a7bf7e342e5739f823a0613" => :catalina
    sha256 "673e17bec4a299423fc52d59ceeeffd126f9f5ee4c134002bfeb7ddf29e317ff" => :mojave
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
