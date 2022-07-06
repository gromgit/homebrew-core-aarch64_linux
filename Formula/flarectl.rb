class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/v0.44.0.tar.gz"
  sha256 "16a247764906894bf740999b6063fc21eaac33e8615d33635336746726dd7881"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fdc01ed31231f75b4a8132a314b3a9e8158dc13d153282151f9bb502b112846b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "be4f58cfe9fbaa4ae6003f71db98fe9a7bac39c0858a7d6aa5ab01b46d5cf0d3"
    sha256 cellar: :any_skip_relocation, monterey:       "a08c8543f7699355a080ba7efee358180f192c4841dd1aee1d5a3469997b365d"
    sha256 cellar: :any_skip_relocation, big_sur:        "aa0e1c31f0f6bbcf8d52c9b6798045c09075b1622cacb8ff9838bc77a4931a49"
    sha256 cellar: :any_skip_relocation, catalina:       "5b1a755808a5d421445390117b636fd77b250dc1e42ffd2516936a5ec3b1ed2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa0b7c809b8c6ab8827cb7d1113230c7962834cb5b700d921e26c9654902d1d8"
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
