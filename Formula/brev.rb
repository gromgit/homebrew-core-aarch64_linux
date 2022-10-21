class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.128.tar.gz"
  sha256 "8484ed849f68f17d973cfdbb7fc28cca2d390f48d3e59f6c35ec8b8ae91b51a4"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b4dfd2211c70bc9c8c84fd6f846865f4a32c8f9572a4bd0035199cf8f60e1a40"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6392612d18d7c10269112299c91f5686c9b994897ae6a10be47c6147d88bdb05"
    sha256 cellar: :any_skip_relocation, monterey:       "5822621f1a56dc08bb239b73502ae8ab9138d90cf3ba255da2251760b2393b4d"
    sha256 cellar: :any_skip_relocation, big_sur:        "7212242eaab52cae6a208e20015c9c56b9e8155473c403bc66a2ea391dce9b8e"
    sha256 cellar: :any_skip_relocation, catalina:       "b72f12b9e0689793d1e0bae024a2f6b80f94cbf10d16b04c15bd779122757c67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72418d6c59ff9ac6a8403df7d2d0077ecd5a330994ae33e2004c1ccc287f498f"
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
