class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.67.tar.gz"
  sha256 "77621c381242d8a1d7ba3d76a9c675982840d4a1cbada300dfad4b08adde3924"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "42ffebc6779a4ef4265361c1d3c882125b9608ff23da69fdb240bb41cbab1a3e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "48099adbfd12726db160f4514f2a138756657cb46a19e29ad16014da331ce42e"
    sha256 cellar: :any_skip_relocation, monterey:       "35f5cef42b0bbae86187a313d0dcb1bdc68ebd3d5e81016a76e39d890e03f4d5"
    sha256 cellar: :any_skip_relocation, big_sur:        "b1d217a0a0f8cefbae60e639db90feab11e8d7854104af07e3ba42f0dd7e9a9e"
    sha256 cellar: :any_skip_relocation, catalina:       "6e5ede78f4c5e38a13d9998fdf3ba27d0a2b884a0a704450eaae1cafd7396204"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61406b76fd99053a29b3cf9cc3a02e5d36dfe7ebc06b6a6c2166e4d12f710ea5"
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
