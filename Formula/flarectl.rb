class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/v0.45.0.tar.gz"
  sha256 "daaea3417353e0a03775834d30dbe09a319c6ea1eb674ea94a7113c6f993dac8"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e8d1aaf52c2eb2d8ee327d3a456bf129809030a0703c41d2b1e84db0f935169"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "df7ad16ff84664eb285578a5f1e27427e9d30934eda6e27d2af72b7a4fb54d55"
    sha256 cellar: :any_skip_relocation, monterey:       "8905ad5da612515b9759b08e296477b2288969717babe66dbfa56c6e4c809a75"
    sha256 cellar: :any_skip_relocation, big_sur:        "d44d318c628f4d52b13a3953b9595f821ccd38dc7bcff1bfb5ab8851ae1840dc"
    sha256 cellar: :any_skip_relocation, catalina:       "a012f24b78aff80e79e8b4b069912869c310a7fbca586f4aaff09a191d775266"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3fa6ba3af461a768394b04438f3c002c7d6aec256b92ede41039d3257229d9ff"
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
