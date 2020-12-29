class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v0.12.3.tar.gz"
  sha256 "e19fe8dc70762f1ea2c56ae9f1c0bc2ed2d7b38efc2d87eddfca3d92cd0cc37c"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "0add0adfbb2b7c98247ba720e5b55291de38019d08584830a1bbdd5852ef0f82" => :big_sur
    sha256 "099d7c82462b61bf72730e3063968ca78d17f690bbf03c178317c34a33026d1a" => :arm64_big_sur
    sha256 "db183d2c22eb8884717965948bb902a2b9ad9797bd1568c291aae6514ebe9b22" => :catalina
    sha256 "cf8eb23062324486436af885bf4329f6d20d334156b49e75156e68e526a1219c" => :mojave
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
