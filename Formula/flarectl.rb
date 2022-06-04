class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/v0.38.0.tar.gz"
  sha256 "d024a5cc1187084ed1c3ac3f46bf029c8e138ed8d20b1ff262e19f895724ad40"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "97b302da2c4dfb3d86004762fd69d7ffe63d2ff8f34471fbf00ed6145b2735e7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "05b6b2f48bd0f9bd9eb07b178dd26de39fee25a1dc190dc0a8fb99ed5b59024b"
    sha256 cellar: :any_skip_relocation, monterey:       "c3f782c5ec39dac0b35233f538b44e93ea00d7cb35c5eaa4dc1f16468bfd5a1f"
    sha256 cellar: :any_skip_relocation, big_sur:        "ca91aea1215d6c25dce29b78b06feb19f8c71c6dfbab1a7b92f456f3a33b1534"
    sha256 cellar: :any_skip_relocation, catalina:       "79c4eddde0974ee2d2ab072f288b103ca5db3de5541e6e67d8fe713adafed83b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e5000c6f4d84dd1412572d8137a997eec836c3897f12bfac2ab45c4d0d91762"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/flarectl"
  end

  test do
    ENV["CF_API_TOKEN"] = "invalid"
    assert_match "Invalid request headers (6003)", shell_output("#{bin}/flarectl u i", 1)
  end
end
