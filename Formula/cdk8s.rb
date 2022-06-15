require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.21.tgz"
  sha256 "5cd41c36d697ac3d9208acc37b56fa9420c0afc47a01711f2382374a3b7f10a1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d908bbf5f6a8ff13f9ff43c2c68a9428a0d98475d7eb8ce3f0026d44d7efe2d4"
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
