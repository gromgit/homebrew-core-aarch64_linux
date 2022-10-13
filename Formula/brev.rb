class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.119.tar.gz"
  sha256 "ee6e2d0d2a31a6785a466c0168e97d5e0bd25be29c7fe9aefddd2f465488de84"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0482052f545291c465f45581ece0349e6ba8b3407357e38f361a51135036c98c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "be89884ac6bd5e4b97f552507c8f722609e6a04271e9a22b9e0614dedbaf7768"
    sha256 cellar: :any_skip_relocation, monterey:       "cfee5b7d4984199b253b869cd9cd7e2e4a00e0f9ca697927a07265d77d661cf5"
    sha256 cellar: :any_skip_relocation, big_sur:        "6240efa432e9bc7b02d3e87dc34759a5d2ba7b89efc2ade40d001f0adb02e196"
    sha256 cellar: :any_skip_relocation, catalina:       "5ba170f5c3d79d2e82e74b7269827afe112b7939d8720c062b8b231140ec900a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff5fac99d87ea51c6f68be30fb2182429fdfa74bfc6f939b8dc69b892128861c"
  end

  # Required latest gvisor.dev/gvisor/pkg/gohacks instead of inet.af/netstack/gohacks
  # Try to switch to the latest go on the next release
  depends_on "go@1.18" => :build

  def install
    ldflags = "-X github.com/brevdev/brev-cli/pkg/cmd/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"brev", "completion")
  end

  test do
    system bin/"brev", "healthcheck"
  end
end
