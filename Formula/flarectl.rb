class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/v0.38.0.tar.gz"
  sha256 "d024a5cc1187084ed1c3ac3f46bf029c8e138ed8d20b1ff262e19f895724ad40"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a1434c1e00793073d874445f948286afc1750ea9c679babdba92742cdb05b9b8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "61e6dbd25fda4110d099903b33b52dde38498ab8ef46466d436323ddc4eefd84"
    sha256 cellar: :any_skip_relocation, monterey:       "219165a7ee03ecba84931c7e14663f5b39ee5c1caa2d90d13149f62a00bf9580"
    sha256 cellar: :any_skip_relocation, big_sur:        "ab871c197ab12232700d3dd4b5ff4210abc4d1511774996eb0374aa68ea69df4"
    sha256 cellar: :any_skip_relocation, catalina:       "b2f6923bb15280a6fdacf21d0eebb2824206aa48ca51d9f4ff87827c075515c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a24e57645a1852bb7df15b1dd5e49e1eb56f86681a3b81884f4a69054939adec"
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
