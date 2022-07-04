require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.40.tgz"
  sha256 "0a27573eece65d8b5d5a2a97af5a7953661f8d2c573e85e2d24a43a9add79839"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7b68e64018f49bc16c48b851c1486b5e1e469d49c63febc3fa112614350581be"
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
