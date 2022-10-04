require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.4.tgz"
  sha256 "2ee31e49092df9f7eab6b0ad7491ab4a0f2ab319e06a6f43244eb0a95fab25f6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a052cf65e09537e0b2e18e2249b609f27ab91acb51c542d3e46474741259cdbc"
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
