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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b75b3b60d3ce1bb1d9f2815f3437a299e4f6d2610c1855996e6d752269bcaafe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a6b237d451bac9c0f830a5c1fc1acc3ca20e71bf7065a17867249c372ecaef8d"
    sha256 cellar: :any_skip_relocation, monterey:       "c1d8fb7ceb1704bfca7bfae7bd36877ea343d22b2d92b73ab62390d499ee6686"
    sha256 cellar: :any_skip_relocation, big_sur:        "d8a630d1483cfd2408e318bb04644ddc05fcf97897944f9c0edd5ede43f25261"
    sha256 cellar: :any_skip_relocation, catalina:       "685342bc877bc31ec7d5fa70ef84ebee1ef63ecb34014ef3fc521088ad343b55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69a4080501d0a1de61653df4a39c3a8b311f5e4f7f210ac46da6bbecb4d7d818"
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
