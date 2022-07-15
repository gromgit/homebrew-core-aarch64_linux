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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec831759090d6aee53394b4bf7e098189bcd0b02951dfc261cd0ba36d83e2b1c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "69425ea2e0dda7803386848192057514e3f3821de10fd00a0fd587751e4b57ed"
    sha256 cellar: :any_skip_relocation, monterey:       "ac15f2840372d6691f9a51fe097585336177fb8918722358f3d59590f77db7c2"
    sha256 cellar: :any_skip_relocation, big_sur:        "59cbd15c2ba78981ea99f6bb8b145a948efbcb93ef719efbb4c89cfb30910c8a"
    sha256 cellar: :any_skip_relocation, catalina:       "3c0eda36f879ef8cb50811300904bb00e38ce105dcfcece7fd26210146e097d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bbf887a4f6697d29663a3de8cabc9d8ef0b84d17dd8d39e89ef7b217d2be061e"
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
