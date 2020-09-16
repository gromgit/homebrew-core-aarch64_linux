require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.4.33.tgz"
  sha256 "c40a529a7dd791e22454353255ee37ec41c17e1bd6975c96b30171d8dc202c4d"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "a2eb8ccbd5b44d3be00bf7490b234ee6645e6578d82dbc4f44f32452cebc6113" => :catalina
    sha256 "dfa3ebc6f748d933d86b9e5801b6081a71fc5fc226e327205bc8c4f754954fdb" => :mojave
    sha256 "fc5fb7648bfb175f55aa587d83eb0c65a1b849fdfabb82b62999a6b6867dec1a" => :high_sierra
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
