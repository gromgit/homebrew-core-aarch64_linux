class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.118.tar.gz"
  sha256 "1d0ec8807a44e1117c35045dc0b414ee3c0404e610cb06a4e35b980fa0bb80ea"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3fad32decfc4ce28de85d4d3e76d146822dfb8b42824b792f59fe08b89efca60"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "761560d0e62bc140ce52649dcbc2140ecc8bf96f1618b82c575e957faf2526aa"
    sha256 cellar: :any_skip_relocation, monterey:       "5df64de6ab169474e100273b9cfcca1d5d1544bf4b857e0f414f5b175f08f770"
    sha256 cellar: :any_skip_relocation, big_sur:        "92c176c08ade6e41753493b701ba34005ab6d4d8991ccc67251ec093f3231e35"
    sha256 cellar: :any_skip_relocation, catalina:       "879bcc24dccc1a0004417d661f21af0bbe293688b7e749ae49a8478ed27f1d34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d96b47e178b8104a872e6836a0cc37a5f02aee982061214ed89ad140077a3d9c"
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
