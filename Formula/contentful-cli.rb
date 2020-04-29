require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.3.27.tgz"
  sha256 "8a570d80da9da62f92005e37ea85cdd1353042a1880d6913a177f81f0b4eeb57"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0f9d33e70cc9aa91b76ee79ab7b08cc44a2d6e0592be182724629def4e695b9e" => :catalina
    sha256 "08c824c41f17b3e6971a408e9c3bc90ddf50de31c8dca89b171e17e5996af6e8" => :mojave
    sha256 "76867f1cd36beef0b1042f1db7f856e76155af49014ea5ff3d79fd04c8f55061" => :high_sierra
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
