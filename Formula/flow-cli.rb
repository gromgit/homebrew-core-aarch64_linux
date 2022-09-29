class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v0.40.1.tar.gz"
  sha256 "19674c8497dd706250274b04f8bce0336295e3e53132631ea64d471f49ecf152"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0adc186b63970bbaa9617ed38e862dba1eab9d0471f3839dbe633784d4cf8096"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "738399628502331ce43c610009fcb264b87daea4b3d1f7b15bde0e8fa22010c0"
    sha256 cellar: :any_skip_relocation, monterey:       "db221a7a111df5775dbd9a4e659695c387af04f0ca5c81cd3867f184f520998f"
    sha256 cellar: :any_skip_relocation, big_sur:        "4c925390a0708519690c1c535d368b2280cf3b0b9748ac93f4b14d28f4256f8d"
    sha256 cellar: :any_skip_relocation, catalina:       "16f7eae760adabac0a1a808f0ef0c943c861d2f0d550fe78e82fac465bb8a18b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e420a0f901c72f32a59b6d1fdcfe01014907f5a739f7857df4452726fe0c5c72"
  end

  depends_on "go" => :build

  def install
    system "make", "cmd/flow/flow", "VERSION=v#{version}"
    bin.install "cmd/flow/flow"

    generate_completions_from_executable(bin/"flow", "completion", base_name: "flow")
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
