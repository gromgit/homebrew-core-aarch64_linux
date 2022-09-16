class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.108.tar.gz"
  sha256 "bbba077cbbd8018f9a80bbe368607297990beff8d0c32a6c5fdbf326c2abaef1"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ecc439c0b7104e0453f8517ad56697842091919f05e293d26fb548701faa91b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5384b9771ecfbb0b57882b7ce1e2cf98b7f01e6bf07914ec8a2f879a9d05f40b"
    sha256 cellar: :any_skip_relocation, monterey:       "5749a9be978ad75bfa5124e763338384969d97087ddaadc6758f38ff2246a82a"
    sha256 cellar: :any_skip_relocation, big_sur:        "c037608c35a86428c7595b2f1eea584dbeae3e2816530e46a068a675c9fb77de"
    sha256 cellar: :any_skip_relocation, catalina:       "d5f9bc7a856dd6cc90f6fb529b735cfe050c0fb107883127b604151c7f080406"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2e944ace3437a8e51dfe6da5a113c0bf81f6dbdba304bc1997fc03528df2aba"
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
