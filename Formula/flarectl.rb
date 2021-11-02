class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/v0.27.0.tar.gz"
  sha256 "b7fc9518dd1e6f424074cd1e3e199524e27592bfe28a0281c05744b89ec0f4aa"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1cb126716c8f6ab4c04ce0ca9e86a2cabfa0837399a131b79f61519484f0270b"
    sha256 cellar: :any_skip_relocation, big_sur:       "1a6d275f539c8c15f4b63c7156215c92f74e8d2cd7a4dab005b40c84044cc80d"
    sha256 cellar: :any_skip_relocation, catalina:      "338a9d58494858001a252b30ef0d3a3c8e66687678746c39139fddfe8aefbc74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f19c09e937d72908bdb55494cbc3a5f12e975eae89caa9567e53aa0e1b51c1ce"
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
