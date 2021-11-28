class Mmark < Formula
  desc "Powerful markdown processor in Go geared towards the IETF"
  homepage "https://mmark.miek.nl/"
  url "https://github.com/mmarkdown/mmark/archive/v2.2.20.tar.gz"
  sha256 "359810382ed4ad464ca74c38faa93466304959bd4fe4c2d4537a152399e6a362"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "59c9598b21f87975b6a4631473b882f6a7e7621604199a2d98107cf6095d8897"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "59c9598b21f87975b6a4631473b882f6a7e7621604199a2d98107cf6095d8897"
    sha256 cellar: :any_skip_relocation, monterey:       "6e9b447b2283653607f40826da75a58099eacc086c9be99b69112df999765865"
    sha256 cellar: :any_skip_relocation, big_sur:        "6e9b447b2283653607f40826da75a58099eacc086c9be99b69112df999765865"
    sha256 cellar: :any_skip_relocation, catalina:       "6e9b447b2283653607f40826da75a58099eacc086c9be99b69112df999765865"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1fb6c63c3300ebb9cb2c275ffd760f8507115c421e2ed5ada73b267e4b613298"
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
