class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/v0.19.0.tar.gz"
  sha256 "f0ed63950bfed416d0f085e4e753d27d8a9baf0d2f1f83670900a73336809926"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f5fde10ed87fc9ce8b9caa717ec691442556b75493002b0c9ee471a33ef81a19"
    sha256 cellar: :any_skip_relocation, big_sur:       "4d9645e8cda9639823c37036cfb2bb930edeb524e1b551d94020033146491c6d"
    sha256 cellar: :any_skip_relocation, catalina:      "0c8765e93fcebe45e3c4b8eb7c118013fa5f9325396932115951b5f3228b59e4"
    sha256 cellar: :any_skip_relocation, mojave:        "31cc48e6267377eb496350cbb8b8b6e3f1b6801cb1a4b1855a861bb8be3107e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2629f46b3b892920ef4252bc4fc8f931c8327f47c9676665a826df50b83470be"
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
