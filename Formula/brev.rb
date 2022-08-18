class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.94.tar.gz"
  sha256 "7c9a8e5daf5f5f4035d8d72f705404fac13415b7c463a06b105c1d5805161236"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a32a15838ec547af1706f592da487e49e3db0902d1ed4b15552a4992cb5c838"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cc78a932d79225e4ad279a7c2eb5c535a50b36ebfff1693a9603e4c1015ed99d"
    sha256 cellar: :any_skip_relocation, monterey:       "b73bfc3cea95a9a7fe2ba7efeba0215465294d9252dccbb7534a9686e6c389f7"
    sha256 cellar: :any_skip_relocation, big_sur:        "39fbfd567249888943cab8387eb58dc64c28c62e508fcbeaa0c843ec182597db"
    sha256 cellar: :any_skip_relocation, catalina:       "eab0ca0b406162b8bc3c25b92e680a88b41b46401624a0629db61466b45fb4a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ea7e321077560959d2f85623b02e409a5aa0cee559f521d12a3a3fe786da955"
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
