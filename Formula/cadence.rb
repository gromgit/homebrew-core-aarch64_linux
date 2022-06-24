class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/v0.24.5.tar.gz"
  sha256 "5582f669637f00afe3004ad8323664a8da11f722b072c18808a2e538e0f5bb9d"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7cdf07584feb3936f382d55b7a684c363e531e32afa03e5a58feeaf2d4fac500"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "22a7537ca1338ffc9ff237cbfcfff4d4a8bb21cd02b100455dc3f5b4f35c9daf"
    sha256 cellar: :any_skip_relocation, monterey:       "86a6da9c9e5ae91bfb0632273cf228f626fc0737b92073a580d5e2845dee1be4"
    sha256 cellar: :any_skip_relocation, big_sur:        "017a295fcdfba822920d02e6941b60bb1d07b7ab986627904e9c2d7625eddbca"
    sha256 cellar: :any_skip_relocation, catalina:       "4836de258ce15c2dffb6c664c99a038f8fe7b6d375beb72ecf05b1197dbf4473"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2dad9be534b31b6b469bbaa8c79aff9a0e6e701f00896f9fa9a9a98651767c64"
  end

  depends_on "go" => :build

  conflicts_with "cadence-workflow", because: "both install a `cadence` executable"

  def install
    system "go", "build", *std_go_args, "./runtime/cmd/main"
  end

  test do
    (testpath/"hello.cdc").write <<~EOS
      pub fun main(): Int {
        return 0
      }
    EOS
    system "#{bin}/cadence", "hello.cdc"
  end
end
