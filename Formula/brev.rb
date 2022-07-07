class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.86.tar.gz"
  sha256 "fed896684d23f4db2aece3562f8b4ffe976c57f1dad4ae3bc04d4cde3580b73d"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ca15679e01a4517a95f83f1c7192fd3bdae275c31804864d7e290bdffa122bc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c205078d783afa06ba87d01937dfb4a5090a714d4196d912819d909ddebdbc0e"
    sha256 cellar: :any_skip_relocation, monterey:       "abd077faf1199d36f4fdcac967bf2d7ca01c3ff47de3fc27342d7f5da13a1de6"
    sha256 cellar: :any_skip_relocation, big_sur:        "49db499a78e45544215004e4990650951f5f5939388c7ae2f89017fe1dbc4b05"
    sha256 cellar: :any_skip_relocation, catalina:       "8f3534c7a88d8b4606073556512079db72a8d91ff66f4096c28b7bd8cdf810ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb90d844a44863869cbd89b4ac142b3bb853acc733ea4b4d33bccac7a57e051a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/brevdev/brev-cli/pkg/cmd/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    system bin/"brev", "healthcheck"
  end
end
