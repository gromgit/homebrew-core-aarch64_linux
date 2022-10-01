require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.1.tgz"
  sha256 "e98431a451c05d9adf7aaa844807c6c9c7ef0d2c296d60d38f1be5ac3d4aeae8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8f0afa18b9d68ead82e8f8747304219df54d2bc042f038f365d77b5d10f63652"
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
