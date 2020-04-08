require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.3.10.tgz"
  sha256 "13448cb81db98c63ec998314b3bc6b9408a22cbffa705e41e86883b56c498a32"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e83fea86dc33599ef4e3897f16e3dee8f2a59eeb13a10bea18e77904eaeea6f6" => :catalina
    sha256 "7fe55fac00328d85a510b9e154ff97ecf5ef5d34ebed860b212a82071a15f0a4" => :mojave
    sha256 "c2706185e4f9b340500731d6ae6aed20b8d1e6d89d15b94ceb907e4fe19241cf" => :high_sierra
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
    assert_match "Or provide a managementToken via --management-Token argument", output
  end
end
