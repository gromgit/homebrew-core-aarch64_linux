class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v0.30.1.tar.gz"
  sha256 "8b90e5aa3d22114733e3b9c458cd51f6aab0b639778620e29b613f967c133c80"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c6fd07c6bc5f0ba45be7bad2691a193d0312cfc6be58e18f655d372c60b531e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "df7e72fed956ea5e692c1ce295f4a0f9c8e79cc2463fbf736f41459014e83857"
    sha256 cellar: :any_skip_relocation, monterey:       "4a75d3237a3599cf63af8585962108f85f44bbc603100d8f2948a3a86d8a7e33"
    sha256 cellar: :any_skip_relocation, big_sur:        "15e2b6795feddf706dea37a29b0a120627d320ac67c491e112b61b604f761450"
    sha256 cellar: :any_skip_relocation, catalina:       "9a883ab3373e091cf3303af42ddcc63896659a11fc872ac890c53b12dba8f3c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03fd6257369386182060f73b60a3da2396fcd0e01f90173f441b1f18c6f37681"
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
