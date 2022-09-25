require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.120.tgz"
  sha256 "acc31408320b93e1d557ebb1a7375928a4df3efdbd43b9a382e010be70767255"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e554ff77789e9902311ba85d6569cdfcfa54dd3eeab237ebb721ffb13c2183b2"
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
