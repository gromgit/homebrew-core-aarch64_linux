require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.3.25.tgz"
  sha256 "ca6fcdd21447228c9e230c472bd20ce14c28efa6565247f32ec3359a6c883426"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d8e974095ebd3ee29be5c9e0c8c0821165e65a77609c74fd7d851bdb4e006238" => :catalina
    sha256 "60ec69e331df05c0ef0becb3248732dd19691ef7fc51982d29da922326c7579d" => :mojave
    sha256 "0ad506b76c8bb64f525a395ed9b37fc3c60e289315d192fe523b47e5fe9fa7ce" => :high_sierra
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
