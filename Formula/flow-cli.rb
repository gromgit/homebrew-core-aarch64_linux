class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v0.12.3.tar.gz"
  sha256 "e19fe8dc70762f1ea2c56ae9f1c0bc2ed2d7b38efc2d87eddfca3d92cd0cc37c"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2091b5c6d2cc1ca40fe0becb7d9ae220a2fdfa04007f68e2b208ccc47e6a38fa" => :big_sur
    sha256 "4ff1e18a1ab967bdb2639e22ecfad641978254e0f27efb53d7a2524a23ad66c3" => :catalina
    sha256 "073ada55004d6794579818d179e0a7d515585d389b494b9e408aeb4ed5902433" => :mojave
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
