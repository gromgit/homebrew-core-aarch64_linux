require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.4.3.tgz"
  sha256 "3094e46fa703d1407282b6aae4178ecb69cb199cefd5f0c50b2eba3dd2788060"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "97b6d18f0581b25fc548ab726dac3a7f4baa1ff6ec3e4d7e80c553e6ad3e2e39" => :catalina
    sha256 "c730e00afd5f7e82f373493f0af1fb04f375f87b699aed268d9871e12dfad732" => :mojave
    sha256 "7551cd22ec70d3dd48135342e83a58c77a2a4ede3b6f6c643d9651a11ca69c40" => :high_sierra
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
