require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.6.tgz"
  sha256 "e8fd9f4cbeae17758a240ebe1a638ac4fd7ecbb7cedcacc77a99d815e5912768"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7bb5e01930a9ae7c44f01c8690f9212d925c8651e3b1fe462f0a37b8fec026c8"
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
