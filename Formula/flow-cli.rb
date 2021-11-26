class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v0.29.0.tar.gz"
  sha256 "b6db258501690153a95be9379be006e315e3a359394238c27687d9dfd7c24641"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75aa59cb25ca60e4a955f9aa036424afbd07524b46aa1cb21ace9237a47fbed5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4492e8dcb69c3d84e87c3029968736451e75ecee525c673298eccdc7d5991dda"
    sha256 cellar: :any_skip_relocation, monterey:       "57f010a1c7ce149c0a460ce1c207fe9dad96966c80a6fa5358a506e041003d3d"
    sha256 cellar: :any_skip_relocation, big_sur:        "58572a959244bb9e6d5fa3158a1d9f46619c0ebe6b73bf3f6e6a8e986216aaef"
    sha256 cellar: :any_skip_relocation, catalina:       "71da142f11b5f76f698f0cd7aac7db3647d3dfbb7fc245ee02e005d32a3bcfc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c96b96917c7139e05bf0b878e454e798e8b8112e27cac5b4d8d69e56727caf54"
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
