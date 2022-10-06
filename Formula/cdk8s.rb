require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.6.tgz"
  sha256 "b96eb4cedc2fb71d14e408df88f9ff70a109ba73dee6a10357a16c53eb881495"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "588383eb3532e3893c88fee349dd8c32448e5c1a25c05ca0ce8d768e5ca976e9"
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
