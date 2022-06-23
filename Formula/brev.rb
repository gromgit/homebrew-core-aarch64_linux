class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.80.tar.gz"
  sha256 "1e8a246ce9211ad08f4be6d1f50696980b537a445b735c2193635409c31c6ba1"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6adc961a9488ca414e1de00cca55d1a80f524435ea30ce6f7c6e48446280eabb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "145ce2d76db53aac734c4184aad309f1196233b7e9ed45a163bb2daddd8b9402"
    sha256 cellar: :any_skip_relocation, monterey:       "91a01f847d2da4f7b33495f03b97c7663c7afed95955fb22fc55279ecfef87f1"
    sha256 cellar: :any_skip_relocation, big_sur:        "23f7b05b74a99fd52d93450bccf9bca41c6887fb096d5ac2ad60f2128daa6b42"
    sha256 cellar: :any_skip_relocation, catalina:       "b14ccd04f663e6b1cb1abc03b0793caf0d0c1b55a1f47106f02fd5d6fd1aee83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18065a9dfa7957167189e2f68d42f25a001ac8fec381c7b379bf33549d813291"
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
