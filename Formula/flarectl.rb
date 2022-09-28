class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/v0.51.0.tar.gz"
  sha256 "41d2d534c8f8a4d4ea95f6715ad08be7bb92eff97210395793f8b0dc33dd41ec"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25873e9f159571c23ac48fda69275a1ae36845c1b1c91062fbcd19e45f8042c9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3363528e80e25255ac14e56bd99416b84859ab52653fb5c2a72bfa6fdd936431"
    sha256 cellar: :any_skip_relocation, monterey:       "ede671091f8e68d0a79b9e62174d159732b9a732446125b6e8f9a36e53200f25"
    sha256 cellar: :any_skip_relocation, big_sur:        "0030fb80249ad39f64f19824b27cb4e9216b7791bca33bf5c9489bf8b34e705c"
    sha256 cellar: :any_skip_relocation, catalina:       "c38700a190efbe0191c9000ee8576c3029984d4d5992dee3bf654b939f45cba6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "108150b2892cfe7f9b0dca196a675795c8cfda34cbca7e790ed8671672dfd7f7"
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
