class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/v0.29.0.tar.gz"
  sha256 "a9816362e96030f5981250b4a91e313190ad6ed5f49094425490947d4afedcec"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c445012804ba69cd909908096ccbac12e3c9f48bad1196fbbf5bc095cb1f65e5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f424f7b759fbc3600a4026cea6c497fd5c35054fb79d61dab1387748b8d752a1"
    sha256 cellar: :any_skip_relocation, monterey:       "709e2bc8f560afd8f2e5a837e118992da3811239c98d61c8cb15153fd9be7295"
    sha256 cellar: :any_skip_relocation, big_sur:        "cbe89ab9c163fb26e5204c59bd079849d68b0bfe3dd9399d452c5735d40a7670"
    sha256 cellar: :any_skip_relocation, catalina:       "d070ccdbcd6f0e7c7b115af01a59ac706c5b139cc1b73ade9d9cd414112c218f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7254a6c066aa87c11256f9e59c299e2cdf97f351c961871b11110bf94e9aa00b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/flarectl"
  end

  test do
    ENV["CF_API_TOKEN"] = "invalid"
    assert_match "HTTP status 400: Invalid request headers (6003)", shell_output("#{bin}/flarectl u i", 1)
  end
end
