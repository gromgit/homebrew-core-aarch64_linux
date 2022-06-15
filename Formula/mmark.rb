class Mmark < Formula
  desc "Powerful markdown processor in Go geared towards the IETF"
  homepage "https://mmark.miek.nl/"
  url "https://github.com/mmarkdown/mmark/archive/v2.2.25.tar.gz"
  sha256 "dfc74c62cbb3c32ae1895ea8f067829752ece09e91c157811c699a840e6b2b94"
  license "BSD-2-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/mmark"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "1470b5be69a88212dbf7297efd4a1647bb32045abb79fcd01d4b38571b84cbf0"
  end

  depends_on "go" => :build

  resource "homebrew-test" do
    url "https://raw.githubusercontent.com/mmarkdown/mmark/v2.2.19/rfc/2100.md"
    sha256 "0e12576b4506addc5aa9589b459bcc02ed92b936ff58f87129385d661b400c41"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    man1.install "mmark.1"
  end

  test do
    resource("homebrew-test").stage do
      assert_match "The Naming of Hosts", shell_output("#{bin}/mmark -ast 2100.md")
    end
  end
end
