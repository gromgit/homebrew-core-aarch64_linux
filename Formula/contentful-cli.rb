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
    sha256 "c741ddb7bc2e6fe232baa246e7838926b013a9979b824f1a3dfab5c2292ff478" => :catalina
    sha256 "0b7a69b410623618424d5bb5b432b1c84224fa681b6a5a58c33627d68ecd72b4" => :mojave
    sha256 "77c336f100fb43cf09b4db590dd5a34c4d4b4a30dedc8aab7a70b4525f969556" => :high_sierra
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
