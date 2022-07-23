class Naabu < Formula
  desc "Fast port scanner"
  homepage "https://github.com/projectdiscovery/naabu"
  url "https://github.com/projectdiscovery/naabu/archive/v2.0.8.tar.gz"
  sha256 "2cd6e5a0ae74442f7e401ab714c85dbc2fb10befa3663e793dbdd717b26072b8"
  license "MIT"
  head "https://github.com/projectdiscovery/naabu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "66ea56697b7ef444f3dce2ead35eb30b8c2866d21a0f96bef6d9752cb542d26f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "261700cc346a79b467599b09d736d31ac13b1a8609105711d3245991bf3a3b44"
    sha256 cellar: :any_skip_relocation, monterey:       "7b6aeca4a8eb6c4e02aa9c9a78cc468e2fb0aabf5a3a51ccf1cac2bb4b546dbb"
    sha256 cellar: :any_skip_relocation, big_sur:        "798df64023eaa7c53385f59369327b326ee1a75cc622ccafaa7ddc2f682f9f47"
    sha256 cellar: :any_skip_relocation, catalina:       "a2270c49741656f39a2688639fe24be109174678751f92ec98a087804c3455e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69ba011532beeaa4d73e51e95830d9fcf5e997bf1430437aca86596fa1ece333"
  end

  depends_on "go" => :build

  uses_from_macos "libpcap"

  def install
    cd "v2" do
      system "go", "build", *std_go_args, "./cmd/naabu"
    end
  end

  test do
    assert_match "brew.sh:443", shell_output("#{bin}/naabu -host brew.sh -p 443")
  end
end
