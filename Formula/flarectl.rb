class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/v0.13.6.tar.gz"
  sha256 "6910559906ff0d727b8b76cc90f7afeffa3117c432d2d34b0670e56fa99dcb38"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7fb5f3992995885604593c9de36aaf5805c95444736591bd0c0ede7f2d7639a4" => :big_sur
    sha256 "4d0a4d3bb0a33b393a44b992ea0e595d7898da141c0ac1cff578c465fbb80dec" => :catalina
    sha256 "a675fcfb7def5e459c4b83b288a4f8fc23984e81cafeefa5d209b6e0ba29fdf6" => :mojave
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
