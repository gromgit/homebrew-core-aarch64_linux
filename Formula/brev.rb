class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.96.tar.gz"
  sha256 "50781a3dc640c7823684780de8a75fee1fdf1ef4267a5b621bf1c2d0cff7b9e2"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b162a8b4afb2beab1d8c8cc0d9d3d6a5b5a3d36d004266395a87258090371f81"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4802ae1e3c7d203b25ae3e32a15f3bc6d031e8b686b91602970dded887689f2a"
    sha256 cellar: :any_skip_relocation, monterey:       "3422ea837b269ed1b31391d24f4cad6e4ca0c35afc5cd36158e7ec6c1b69c27c"
    sha256 cellar: :any_skip_relocation, big_sur:        "45b3016b005af7c51948b0003c7945917aef1922e6bce75fe43d5b454c219bd6"
    sha256 cellar: :any_skip_relocation, catalina:       "7a7b6488f3f1f5defd943af58ee74399bc3f6cf66a429560f936c74559e3e9c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0004180e4e3e85657f55f7bde87f8fcb8772dc6502dcc968f6cd7877fd05a2e"
  end

  # Required latest gvisor.dev/gvisor/pkg/gohacks instead of inet.af/netstack/gohacks
  # Try to switch to the latest go on the next release
  depends_on "go@1.18" => :build

  def install
    ldflags = "-X github.com/brevdev/brev-cli/pkg/cmd/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    system bin/"brev", "healthcheck"
  end
end
