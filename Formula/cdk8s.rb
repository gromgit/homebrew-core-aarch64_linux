require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.115.tgz"
  sha256 "f2ddb080cfd1e55a8dd95e0a582f53dba679c0bdebcec1281181306bb37e870a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5cd70b3499d398286480471c73452d487d3505f8bc5b13365b112dcb77d3e757"
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
