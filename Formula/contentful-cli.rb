require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.4.20.tgz"
  sha256 "d00632f1925f228f21befc821720a5c8f1bb31ec076c40a21df4a80063fbf770"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "98df49d0b27a1da4f6ff3d6c74099ee4d2de1cdb95b3d3f9534cfed69d3de858" => :catalina
    sha256 "55ac0b016e8ac78736b62e6029b03dac0770061ecddf1d5a241b08fd2f216b4e" => :mojave
    sha256 "3d6d7539d83ed92e9cfaee08b15aa85b44aed06451cf522b48b4ee6bb0d7941f" => :high_sierra
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
