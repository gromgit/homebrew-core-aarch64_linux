class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.62.tar.gz"
  sha256 "d6d6fd49b9900122486efa432b56b839d7c21aa4cd2e73abc45037a428230b05"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b9f8128bec130e7e8de3ff2cbebf3db2cf57b653d319aaa7ffdb6f88d3c66d0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "baf445052c82658bd1341e36254339b103853f2b60e9cf3448b6b984ac4c277b"
    sha256 cellar: :any_skip_relocation, monterey:       "6f7085d928c39c86661dd38007cb9122aab8b389a883ab3901186a2cb238275b"
    sha256 cellar: :any_skip_relocation, big_sur:        "a4223cc3f60dc8476b32aadac94304768c45e079508dae5126bac3a9e7c7c7fe"
    sha256 cellar: :any_skip_relocation, catalina:       "4145dd4e73767a9c05466494a1f6789c650cd1e5ae8a7c9eb1ecfbfe6d76d2ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25aa5d4e3be3d6c659f60d526a88243aac7df794c1bbbecfffe10a81dc312451"
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
