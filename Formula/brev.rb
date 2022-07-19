class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.89.tar.gz"
  sha256 "a3576c3f53af6fe521a9b18fe7c732210641f04224976a750b8295b7f6b178a0"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be9a8921b5a82fd9281ed5903339c3c66bee3c08a9810e61d49d1b2c938023ad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "80483b14168f00c2c99a6cf8f7a305277c603e621fc8ab46420ab1a3035979f1"
    sha256 cellar: :any_skip_relocation, monterey:       "fa8591e64b322da4be6224132f689c338e7f2a7ca442d60903046221feffc3a5"
    sha256 cellar: :any_skip_relocation, big_sur:        "a1c8f784abe5ec71884a4e90a3b09c0d9be8ac717ca9366d0fab9d0f9765cc18"
    sha256 cellar: :any_skip_relocation, catalina:       "634d2908a7a0d83f0fa16464fefb2db41055fd9904b8f1bab511b90640369dc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c0b594fede1fe84f44f90e106f23a15fc9d5c1aee47d7790178cc7dcf8eb0b2"
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
