require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.9.10.tgz"
  sha256 "e82618e5ae0348c1dc54aa99dc35c6c922c818cb2f42462eda350cdf9f0985ab"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "be3ec6f7ea8e15b9fa3907a4640e8fc758cb032aaca98ac6e8f43e3118df3b4a"
    sha256 cellar: :any_skip_relocation, big_sur:       "0f9f092e5e650c1f3065b8d13653085d6b53a7bf80ccbeb3e7f871e9c0d3bf36"
    sha256 cellar: :any_skip_relocation, catalina:      "0f9f092e5e650c1f3065b8d13653085d6b53a7bf80ccbeb3e7f871e9c0d3bf36"
    sha256 cellar: :any_skip_relocation, mojave:        "0f9f092e5e650c1f3065b8d13653085d6b53a7bf80ccbeb3e7f871e9c0d3bf36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0081dc6fbf9019acedfd49591a41875abb6efb192fa6a213e2c844f09b7e855"
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
