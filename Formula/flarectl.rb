class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/v0.15.0.tar.gz"
  sha256 "cec2ed713942208618b3b518509fc76f2416d0fd9afc87998f34028b10cb7de8"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "18e349679df45d20e13ab2add8b921574a7eda5eca136d47ba4fd7190c96dbd8"
    sha256 cellar: :any_skip_relocation, big_sur:       "7327acacb193b0715b5dbd37609f2c479a37e6ae42b6a5e38f38cfeeca576ef1"
    sha256 cellar: :any_skip_relocation, catalina:      "5092cec7074c9f8f26d5606cf97954939968cebe48ed99e7070f59715d7d260b"
    sha256 cellar: :any_skip_relocation, mojave:        "017eef36942828be5e71f747608fe4abd405bace10e7bfc0286c92b0ef25fc18"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w", "./cmd/flarectl"
  end

  test do
    ENV["CF_API_TOKEN"] = "invalid"
    assert_match "HTTP status 400: Invalid request headers (6003)", shell_output("#{bin}/flarectl u i", 1)
  end
end
