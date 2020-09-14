require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.4.31.tgz"
  sha256 "36d8c9af3bb648c94c13db7dbc9daf57dfd87718d4196875cbd0f761726ead0e"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "9c630dfa4a9b3ac9b403c304bfc73541bac3b768ef6e88cf2c72ba1784c16489" => :catalina
    sha256 "ffbb00dbdc9c6696876d04dba035552411945e615fb394a214db9b59d3d0e503" => :mojave
    sha256 "6c4ed7f2f05054f5ba0a333818a239dcdf4dd5d0edd5719f2d5d4c773d65b97f" => :high_sierra
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
