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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b709561853c80d1c8caa11b3c44c8e1e1c3371f39cf5e59b219048acc9d4782"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c02d97c985ddd7f23c655ddd1f45e199cea89225e1d7567a004c51f2a09c8fcb"
    sha256 cellar: :any_skip_relocation, monterey:       "95dd51b793277e529da8eb2df604194412cf5b9f3a11151120459966681d7f1a"
    sha256 cellar: :any_skip_relocation, big_sur:        "582955037d15256dbfd559b67d529430a89f6170066ee6f9ad4cbea04edf910f"
    sha256 cellar: :any_skip_relocation, catalina:       "60e35b4198b7426ef9e8a529fbf2e30b33098aba0a343a87178d4936e6e76376"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fcf58f39af35476fb7041da67c2bcde351bdea165916991a918b36fd23e94f9f"
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
