require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.149.tgz"
  sha256 "76e1dba2f28ae4ac6a6f425ad2631ca624f6611ffa89e8477cf2a29f1214a88b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e1fc021cb09179f8598b9c121ed22c58b27b198e435d3dd65e29a7c0691ac1a5"
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
