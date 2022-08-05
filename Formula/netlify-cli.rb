require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-10.15.0.tgz"
  sha256 "0cc99d0715d4e496f9a7ad442fad53a722eae498cf789e6127b4b2c288c5318c"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9f9a9116d8f6001e8cde8b81663673b73cfcb1b44192c8e0e1c522795cfc242"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c9f9a9116d8f6001e8cde8b81663673b73cfcb1b44192c8e0e1c522795cfc242"
    sha256 cellar: :any_skip_relocation, monterey:       "0145d2eb105a646e59d93604ef26ec16c681972804d560f78e0fd339e68c1550"
    sha256 cellar: :any_skip_relocation, big_sur:        "0145d2eb105a646e59d93604ef26ec16c681972804d560f78e0fd339e68c1550"
    sha256 cellar: :any_skip_relocation, catalina:       "0145d2eb105a646e59d93604ef26ec16c681972804d560f78e0fd339e68c1550"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f3575dc6ade338c5bd6919cd04cbd0f6c54119e3abc90dacd02957a86bf9881"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Not logged in. Please log in to see site status.", shell_output("#{bin}/netlify status")
  end
end
