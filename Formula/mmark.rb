class Mmark < Formula
  desc "Powerful markdown processor in Go geared towards the IETF"
  homepage "https://mmark.miek.nl/"
  url "https://github.com/mmarkdown/mmark/archive/v2.2.30.tar.gz"
  sha256 "04c74baadb4c3cd4c32f9e488b4b4e048ddb1b32411429911c827c2817a9816f"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3d669e8f31ff7441eeede65ff6ddd2860cedb688d8b7c7794306d69c9da68c57"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3d669e8f31ff7441eeede65ff6ddd2860cedb688d8b7c7794306d69c9da68c57"
    sha256 cellar: :any_skip_relocation, monterey:       "ee04badb022b18e514b13700850f8764aae3a3f214eac961d5395e7b62307e0a"
    sha256 cellar: :any_skip_relocation, big_sur:        "ee04badb022b18e514b13700850f8764aae3a3f214eac961d5395e7b62307e0a"
    sha256 cellar: :any_skip_relocation, catalina:       "ee04badb022b18e514b13700850f8764aae3a3f214eac961d5395e7b62307e0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1dbd23a13d6c7d1a97bdb7ed09241156aa9ecf3f44b766805764b2ca115daf9"
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
