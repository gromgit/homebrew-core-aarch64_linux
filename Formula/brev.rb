class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.104.tar.gz"
  sha256 "34decf70f69fd3ca6c140d734a7ddf8a29ce3859019a0dcd6209c31099ee37f2"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f09c06896304817e890d455d07a5943a1ed358cc0e0a5d00f01cf773d4b3ec5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9c05c355868a657e5d112965b4b64be68dbe14cb13803d7cf33e018506f28f8a"
    sha256 cellar: :any_skip_relocation, monterey:       "074ac62997f48600544b28fd73bd1c29f6845ef4f72a6cfc89c9683408e84603"
    sha256 cellar: :any_skip_relocation, big_sur:        "b7160836e4ae2cf5dc4ae712e86bcc2bfbb2a2179e2f31665308765806034e6c"
    sha256 cellar: :any_skip_relocation, catalina:       "3fc8e7d54f9a8bce03fbed56d03d1b5b4c95db3dca3e26e5fc74a80b185d1d57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb09b17318dc033b35b75ef58d8c7dcce59f9f6ebd831d54221b7897bb32afc9"
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
