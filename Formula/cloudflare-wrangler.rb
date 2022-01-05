class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/wrangler"
  url "https://github.com/cloudflare/wrangler/archive/v1.19.7.tar.gz"
  sha256 "97e982d4230e5de9d8e6d8f6f20c0deceb40780fce7371ff87634cf41126026f"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/cloudflare/wrangler.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff77c57e90b0356e9d6fe2280a35b7762cc948d7fdae004a080e567231ff2b2f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8c474f59262c190ec0cd5ef5ef0f54cc2b835cd7acc440439c7e40d87652e35b"
    sha256 cellar: :any_skip_relocation, monterey:       "37019021bdf63b71afbcb34b21ef9ff1e252c0a79f0b4ad9852339f17c5a2943"
    sha256 cellar: :any_skip_relocation, big_sur:        "acefa3be4e8567a26bae8314cb5c67e2efb26d2c2275daf60842f14616957110"
    sha256 cellar: :any_skip_relocation, catalina:       "63952c08c34fbad5f65096700a591da14e89c3be0cd4a00b638f568717deb135"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e969815e34e9cff4040257bddf9bceff29220cbd04563dcb299e4900428a0a5"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("CF_API_TOKEN=AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA #{bin}/wrangler whoami 2>&1", 1)
    assert_match "Failed to retrieve information about the email associated with", output
  end
end
