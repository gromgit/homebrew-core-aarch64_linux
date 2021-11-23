class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/v0.20.1.tar.gz"
  sha256 "728849ea1a90764753b1c859c7b3037bf2be68703826406914f94f189c05796c"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5ba70a75220778708a09fef2970f1640449a00a6e26f0961592d4e2db235cef8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "429948f92d88900806e07e13a83afbc8e8d39fa405835a4664255726979231f6"
    sha256 cellar: :any_skip_relocation, monterey:       "c2fcbb36df27d2b3cb2835f6e628d78fcbf50e4daf28f2fa7f48d6749f44cd14"
    sha256 cellar: :any_skip_relocation, big_sur:        "0bad5be4816c5467068b60b61f80e774f58d9e98b96862e1a1d96ba9bc620f28"
    sha256 cellar: :any_skip_relocation, catalina:       "14b5fddfe31e0571a0cf8ad0eb946239d0d42be4511ee3d2172409fa3f043a46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef79023a6f271651c2b9b1547b188567329156cdcfc7fcd11f528fc185093cbe"
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
