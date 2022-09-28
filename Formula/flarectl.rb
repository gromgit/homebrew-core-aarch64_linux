class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/v0.51.0.tar.gz"
  sha256 "41d2d534c8f8a4d4ea95f6715ad08be7bb92eff97210395793f8b0dc33dd41ec"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a1be555ff8622f5ebbea9f705dd8f1a4b61d06548b1b883b618e0eed87fdada1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9e5f615ca9ba0054eb481bc224e87dfd8bb1472d24b5e111815d6a33f80974b9"
    sha256 cellar: :any_skip_relocation, monterey:       "9f8e4d6e0695329c7e0c7a1a231974d35f838d18280845b76c55f5d2e6c527a2"
    sha256 cellar: :any_skip_relocation, big_sur:        "3632c1430296b956eba600fd32cc41539d9ac796648b5ec3432adce231dcc71e"
    sha256 cellar: :any_skip_relocation, catalina:       "691cc42ed455e896d92dd14721c9dfceafdf52c30fb3f5ac004eeb302f6f1987"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6849f578f1ffa13370d024a1125130f43c8ba3ca5ca8664f54e40d528f74dd53"
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
