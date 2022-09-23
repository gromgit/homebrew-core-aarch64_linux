class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.111.tar.gz"
  sha256 "82d0c33288a19ddf234cc6e45d779b636bd50dd1b608aee5c1554b4d14be1b22"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ddd477c5417045412312368032d370990547d0b386d63448758028cdff1c165"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cf1c3391995a5900eb8a2adf74b009ffdbdf522022bc7fcf8a4d036a69b3ed89"
    sha256 cellar: :any_skip_relocation, monterey:       "db1bf5bd80d7903b556ae38b0431e5f97f57d31ee244a2749370dee72dc98d63"
    sha256 cellar: :any_skip_relocation, big_sur:        "02a7ffce36dfd96aaf5ec29ea14b8f6f0fdd346fd84fa6936f1731f0f6246c01"
    sha256 cellar: :any_skip_relocation, catalina:       "be58e8cd9b8a8871162c6c979a4f66e65b9c96c9ae0b120f5b5f782b64fa705c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15fbe2c6c45dc1c96840597ef046e890943391bd7b95b424931a6d8928d22709"
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
