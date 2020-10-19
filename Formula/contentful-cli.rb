require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.4.42.tgz"
  sha256 "89e335c21d8120fc2cb3d645d00c4029fdc2541672f85f17035e7296b783102e"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "13b7e3e4553fd28d10be6c30f329da8d4b9bac7aa899851eeb9e0e77916f43e1" => :catalina
    sha256 "da8401bd1ab68f04995d74b8a3093f67d6b57ccedea19e677a0ca0230d609215" => :mojave
    sha256 "0bab4d4e18d7f643fb51f8d0d601c51b3bb237d950197d937ac89f96c41f8775" => :high_sierra
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
