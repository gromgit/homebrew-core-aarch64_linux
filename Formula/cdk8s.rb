require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.157.tgz"
  sha256 "d4c09230cd472531c301daf690a6d6cb6eac448ce95663e30e24a43f4be5c83b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3aea3992e5be6c6a6da8a27f115cf85b20787cfa033ef8138ca8068434d69c0b"
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
