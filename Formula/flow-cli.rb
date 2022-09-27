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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c5eeb54d4dd6a6b0fc24dd14cf2de84f2561dd7921af7e5c103dbb66c298363"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6887cc054de3ae5a50f704edea0921a28d54000678da0f5c52b899f218aaea71"
    sha256 cellar: :any_skip_relocation, monterey:       "541a4660b1181e8a65e28546282dd2878168151da94ac38bd9213aef61d49e1a"
    sha256 cellar: :any_skip_relocation, big_sur:        "a26fe12205b746c9d35bc567293359402a822abdf58146c0fab2858a6c9460e6"
    sha256 cellar: :any_skip_relocation, catalina:       "7d7b82ef93aa6d01a0b6e3635307500f416c32b2f857d4dd35bfd841f764c8f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9621ebf67f6c5ebb26912a286aec8ee6523e666850238902139c301d9e71296"
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
