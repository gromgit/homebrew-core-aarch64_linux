require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.12.25.tgz"
  sha256 "824e900b543128b8cc8f59794b1856ad0e896e6850c3ae8778c1cc06e02a8d09"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "39607e24f174697feecd3425aa0850471974e482c30f723c33bc400209f5efb8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "39607e24f174697feecd3425aa0850471974e482c30f723c33bc400209f5efb8"
    sha256 cellar: :any_skip_relocation, monterey:       "78be78e4de31dfc8c8c69760811697a9d1d1768ceb6bf36738ea0507f414e426"
    sha256 cellar: :any_skip_relocation, big_sur:        "78be78e4de31dfc8c8c69760811697a9d1d1768ceb6bf36738ea0507f414e426"
    sha256 cellar: :any_skip_relocation, catalina:       "78be78e4de31dfc8c8c69760811697a9d1d1768ceb6bf36738ea0507f414e426"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39607e24f174697feecd3425aa0850471974e482c30f723c33bc400209f5efb8"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a management token via --management-token argument", output
  end
end
