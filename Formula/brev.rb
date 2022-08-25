class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.97.tar.gz"
  sha256 "3d1c10a629a54dce12830c7c15deb6739d5e6b2d204070940b716dba09114ee3"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bdc0cdc50201e6f5dbd80ef0bd4eb1c9ad50f7e597a7b61ac8f5b99d34481d21"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "882dad59234449fae7dcc794162b2e51ee2e5fbb64bbe80c6d0fb460f58a1f68"
    sha256 cellar: :any_skip_relocation, monterey:       "c95d496b9f6f715907fb5cd2bf22103af36843571c0db511a21445ae27b517c0"
    sha256 cellar: :any_skip_relocation, big_sur:        "82043621ea4ba155ff5a7eb6d8d47523d6f547001a4a4ca3a15ff5274d0e1cf4"
    sha256 cellar: :any_skip_relocation, catalina:       "8a0b42c442f837c850c0a1d6cf772541d756750abd6761b1d446274c7393380c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fdd556e953e1afdfe1671377e539934cf051f1b5eb053ac8473bcee5586ec84c"
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
