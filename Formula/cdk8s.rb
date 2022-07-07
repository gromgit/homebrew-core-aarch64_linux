require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.43.tgz"
  sha256 "654cb35bc7da36c6af57cff87c32a7d3caa42fc36c5943d2f7ddaccec24796cd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6ed146703e3e97c2319e18b8e7cc61e28feaeb405b516dc47ade0867439e4884"
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
