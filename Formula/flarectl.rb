class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/v0.13.4.tar.gz"
  sha256 "6b5a9b3fc3176fb481d71f6c7aff2d505c3dbf624f044c19ece131071ed387f1"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2106b583bd9379c43bd3bbb7f6d31baa23500112b9256062485366631e1f45f5" => :catalina
    sha256 "a5a6a2ed2ea41a55b541888c1c9de494903c332a33db84a9a88e59e14abb11ff" => :mojave
    sha256 "0094a1b52cdb846d0c5cd343d9e939cb0dc96afd62242b576c733baff9ca8101" => :high_sierra
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
