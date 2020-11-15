class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/v0.13.5.tar.gz"
  sha256 "88f0519c2805cd4ca4bee4272040081663525d6d308741c6ec3a5005693eeca4"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d4509e700b53564a8f1c3a951de0592d13e26abd5197fb80f16d98775984f576" => :big_sur
    sha256 "609c40ce2c96f6fdae8f2f8fe415397c4920533ff2098dd6a841211463d060b4" => :catalina
    sha256 "20b40950b101ad50d5332cb99210c94f0cd769f7fee8d9f2695f8f6993a2ca48" => :mojave
    sha256 "a68760070f0bc788b4f9790fc0e05e936067edb456e59d857a9cf1d6fcf4708a" => :high_sierra
  end

  depends_on "go" => :build

  def install
    cd "cmd/flarectl"
    system "go", "build", *std_go_args, "-ldflags", "-s -w", "./..."
  end

  test do
    ENV["CF_API_TOKEN"] = "invalid"
    assert_match "Invalid format for Authorization header", shell_output("#{bin}/flarectl u i", 1)
  end
end
