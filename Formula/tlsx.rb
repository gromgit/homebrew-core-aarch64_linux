class Tlsx < Formula
  desc "Fast and configurable TLS grabber focused on TLS based data collection"
  homepage "https://github.com/projectdiscovery/tlsx"
  url "https://github.com/projectdiscovery/tlsx/archive/v0.0.9.tar.gz"
  sha256 "5d541d96022eeb303d9109ae652f8b520e429d64cbd44c1a45515c91dee1b6d4"
  license "MIT"
  head "https://github.com/projectdiscovery/tlsx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e5441176116dfa812811d659d1f2e5fad310a5c29fc5992177dd70c6872a987"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4fb4d6f27fd2d1be0a124889e7cf385d0136fb348daaafbb335a5063912ca014"
    sha256 cellar: :any_skip_relocation, monterey:       "e85f287470afb362cdca558f8e916ff27cfe1e5e5c6d78572bb995809be8011e"
    sha256 cellar: :any_skip_relocation, big_sur:        "0e2ca6225e2ef62c6e7b6b27a28dc8f2a67fdf2ae78e0420b46f3c95a4f760de"
    sha256 cellar: :any_skip_relocation, catalina:       "11623ce01e2d60c75968b065297491b5b7de8e8019c3be050f29e5815a0a337d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f79dadd19af7e6d4d2a68e18317688f5fde5420073eea3a427d2717830d2fc9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/tlsx/main.go"
  end

  test do
    system "tlsx", "-u", "expired.badssl.com:443", "-expired"
  end
end
