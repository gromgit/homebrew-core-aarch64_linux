class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.112.tar.gz"
  sha256 "da20ac681ea4b0e521285364b9b1ceb9b7cced305293e7c67d90a4d40056243f"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6da06b2d6123b249d636fe4454e0e98ca6dc9806982e8baf0c5fe70c27669ec8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "54d8feb1d59a8764da90d2d6eeb681f4c76fda176ff694b7c294d730d190a20a"
    sha256 cellar: :any_skip_relocation, monterey:       "edf3f40e9639be1bf1b3944cafb1380c18170a83f066ccba0223d553068bf162"
    sha256 cellar: :any_skip_relocation, big_sur:        "661aef47846b173815f66b83c3d20132f1194ba6e9764cefa14b8cbbc298ca58"
    sha256 cellar: :any_skip_relocation, catalina:       "715ae721dae642e4bbb521f26edbcd5726e275ce3b35aa904ac761623572fe2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "872feba02ce69695359d4e83af550f16e5c8c52825f9499fe7b3a245daf98984"
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
