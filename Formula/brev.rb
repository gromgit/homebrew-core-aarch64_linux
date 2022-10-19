class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.124.tar.gz"
  sha256 "e53b70f313d9504414aeea0a41c80e7cdb29d61b681a2de9f63d683b37e7a823"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c15df3154404e04c548ce7a98b74f8c94e0b7ec66397888b667c8a12d72acf88"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "39f4a2021a86645b697bf81b35c61bd6f209fc6b310712e7ad0306dffaa189b3"
    sha256 cellar: :any_skip_relocation, monterey:       "e33151a5b92d44e59910d632357c5fe34c192a7341eb907b8a319646662f5673"
    sha256 cellar: :any_skip_relocation, big_sur:        "4e638d1709509329fd89f60e9620418817aaaa797414bbd6b44933e45890d6f5"
    sha256 cellar: :any_skip_relocation, catalina:       "379ecac2f3de7c142b494624ab7f816f63defdca6898aec60e61960c2983d35d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0640ae41f8943f593de489d18e380e7ec627ba3d99decc1a0a5643a3d69537a1"
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
