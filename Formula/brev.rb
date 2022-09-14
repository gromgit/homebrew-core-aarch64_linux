class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.105.tar.gz"
  sha256 "5c7099fc6295f46f3d9061ee7ba8e87513fa21b81c8fe79379b2545e641903c6"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c62224e0f36b6df8b383c37d389dafe764467729693dfe27a568f24c3f833d04"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "42480f4632a251bbaff0f95d33ae31986f7a0141fabb83e525d5e3eced58cdd3"
    sha256 cellar: :any_skip_relocation, monterey:       "a7fa9df878f872cf409d6231d9764b7fc5ac565a9aa6b1ce8a7300cb8fae6548"
    sha256 cellar: :any_skip_relocation, big_sur:        "17729d6057693a1d51837800dfc0cbeeb4e808884a09922baafad8e0665e9d2e"
    sha256 cellar: :any_skip_relocation, catalina:       "11052b88e01665d626308f916610c215b585f69a96da2a6bb809a9e19332ca49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de034d661168254a66370479421f3e83eb215eb0958804e239a179889f319292"
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
