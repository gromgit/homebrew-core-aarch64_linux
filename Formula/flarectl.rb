class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/v0.13.2.tar.gz"
  sha256 "231132369b0508b35018fae37b9c863b0029e4f029663647e8e3d41f8c568f0a"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a8f8a76243ccc78875135b4b221399e1c6ae529e3dcf572f0be2bf949c24ccc2" => :catalina
    sha256 "8a53d81179cc89edefde6a7bb854899ec6d132820c0b34398f9df015170b6c69" => :mojave
    sha256 "9de8751aeb1e885e891473a751759905251f7d7c1ee1b5bb6c322cf2c6d0ec50" => :high_sierra
  end

  depends_on "go" => :build

  def install
    cd "cmd/flarectl"
    system "go", "build", *std_go_args, "-ldflags", "-s -w", "./..."
  end

  test do
    ENV["CF_API_TOKEN"] = "invalid"
    assert_match "Invalid format for Authorization header", shell_output("#{bin}/flarectl u i")
  end
end
