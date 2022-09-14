class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/v0.50.0.tar.gz"
  sha256 "392e04697bafffdf6efad8b8d47578e382d4d2252b2306808306c7d61e90f12e"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "03b06e5a589fb9577dae88ea1167bbbe91b704e1d21a8d624056eb09954fea1c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "99f9390c3c904a5754c93e1eaced90220a98f50e28aa68d1e38673dfa881add8"
    sha256 cellar: :any_skip_relocation, monterey:       "5719ce1d5763bcc7c5fdd4c5aa90ea0fabcc28eaf3e49e2bbe9b21abc97296e7"
    sha256 cellar: :any_skip_relocation, big_sur:        "ccea9ae9e89a25a81723b4ffc6c2cafdfbad8c27710dd4d424662b2b4915f87d"
    sha256 cellar: :any_skip_relocation, catalina:       "1a243664741f1305ab4a8dfb51faa34ba7a4474c84c47055fa70473baa5262b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "924453664da3a568f7b7efea8bc241486a20bfec109043729be94efd778a1dce"
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
