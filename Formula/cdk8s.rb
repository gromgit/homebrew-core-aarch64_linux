require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.41.tgz"
  sha256 "c30a9bd3accde6b2d3ff357d0b52d431c2c5c5d48ad8f0f8fade6a45d0e947a2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a1564cf6f6115354ae2f281cb6dcd124ef8dcffd317b4c908bb17d358915b60a"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Cannot initialize a project in a non-empty directory",
      shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
  end
end
