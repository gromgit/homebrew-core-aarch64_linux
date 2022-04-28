class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.53.tar.gz"
  sha256 "bdcac65af8a3c5e74fb9d3779a09defca22b3d2552eb9e8b79c6973021ffa42c"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a1ded108a36f3b146f27538f5275a7e5d8b314e9e4f8228ba7899f2f15fa1b17"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8a8cd4ba9e41462cf7793b90a6a7ff9c9caf06e416d0025b291d6e3bcc51b2af"
    sha256 cellar: :any_skip_relocation, monterey:       "139777d4b0672a5eb18cf68255a7ec6aaf40300bda6d326e9b8efab68e9c692d"
    sha256 cellar: :any_skip_relocation, big_sur:        "0dd0b7c7680bc34666850029ff97a7494bd80af7b07735dcad8047c198b5133b"
    sha256 cellar: :any_skip_relocation, catalina:       "6a352cbf70ac74b4b03eb39abb5f4bfef51f6ff897c5f8d04f11f1e785237ffd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1c28a5d628748b38e58ae9889b65c32b74439f11ad78347ad908c15db013f0a"
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
