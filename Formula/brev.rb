class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.123.tar.gz"
  sha256 "d089c4799cf71c91b05773e297e48e95a1497aab38f6d5eed5a68114d569413e"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "11d9dfcc1a1605ca83c72f90a2038109ecdde4493b1c3e115389c659ca12fb78"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "91e898bb958057e3d4275cbd765cc5c3251b62f807669bf61d67ef93191ea9fd"
    sha256 cellar: :any_skip_relocation, monterey:       "49bb16ddc406d008c30b0eef06b8612ba7de7ce086b47c985ef60730255f1e62"
    sha256 cellar: :any_skip_relocation, big_sur:        "ba300c33657ac721a13279564e90face1e145bf18338f297745b0150a9aefcae"
    sha256 cellar: :any_skip_relocation, catalina:       "bb4371c21cf2a7e727260f5d0b04194e729f1e6894a8a2a2d10bb54be31447db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec0b11d3c4f987e8b498dadc427aafccd132698786d818d1b04101c68859867a"
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
