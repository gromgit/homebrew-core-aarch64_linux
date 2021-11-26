require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.39.tgz"
  sha256 "edbc42fc05b141e9d7536c9bc3a0872694c0842d5f0e8e31ddb3acd82da1474a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d8555e900ab5d821699da1dd2180369eff019042546213f9deb082dc0f2c35c3"
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
