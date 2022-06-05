class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.56.tar.gz"
  sha256 "a3d2de2475c64d6504cd8013de968f9ad52206f634d7e616d008b079247bcf4d"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/brev"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "d902ce6d743c2c6e4c1fa10513bf68f99db9dadfd03acfff5521fb85d942bfc2"
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
