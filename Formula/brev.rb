class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.110.tar.gz"
  sha256 "da813da961eef14af42d3a733e61e76d1a5ee4e5aba23c720e20967e3fa0ba14"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e52e3ff01ce9c55e391ee6cad4f2858936f7941a8769be7d309f905fad6e73d3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5e0078dac44a510ad57149e0b19527a91adf2aee53a4e983db681076416c8630"
    sha256 cellar: :any_skip_relocation, monterey:       "a06688abd982fe78d3345d2b6b19f9592d8261e29a728b7ec46ec2785bcb7d3f"
    sha256 cellar: :any_skip_relocation, big_sur:        "02418cd0024d0f9d8550b445fa371b513d70cd752a38b1fbe4da48e6b4370c9a"
    sha256 cellar: :any_skip_relocation, catalina:       "d5476f3bc1550671d4571826145da35a281b6e64e4d1899a9471ee7ed0bf690f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "904e3f00e364ada41a200fc48ed9b1d4f32d88a0f37c00796a56249eba567060"
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
