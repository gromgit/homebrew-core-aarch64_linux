class Mmark < Formula
  desc "Powerful markdown processor in Go geared towards the IETF"
  homepage "https://mmark.miek.nl/"
  url "https://github.com/mmarkdown/mmark/archive/v2.2.17.tar.gz"
  sha256 "e40ef682b3cdc7a479cfafad3e70261194183eb302c072485e0d656ea3c2963b"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba1755eedf27b985ecbd081336bc2f9ad8e2679cd3b31e120763049e87698cc7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ba1755eedf27b985ecbd081336bc2f9ad8e2679cd3b31e120763049e87698cc7"
    sha256 cellar: :any_skip_relocation, monterey:       "9205058b0e63a51b74b6030c6890af92abb6a22a0d4aa79fe858c797ed8971eb"
    sha256 cellar: :any_skip_relocation, big_sur:        "9205058b0e63a51b74b6030c6890af92abb6a22a0d4aa79fe858c797ed8971eb"
    sha256 cellar: :any_skip_relocation, catalina:       "9205058b0e63a51b74b6030c6890af92abb6a22a0d4aa79fe858c797ed8971eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "511f863beab3109e104ba2e2c4f42ecacd5946306b78969c9b46d49201da59b6"
  end

  depends_on "go" => :build

  resource "test" do
    url "https://raw.githubusercontent.com/mmarkdown/mmark/v2.2.17/rfc/2100.md"
    sha256 "0e12576b4506addc5aa9589b459bcc02ed92b936ff58f87129385d661b400c41"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    man1.install "mmark.1"
  end

  test do
    resource("test").stage do
      assert_match "The Naming of Hosts", shell_output("#{bin}/mmark -ast 2100.md")
    end
  end
end
