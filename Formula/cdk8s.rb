require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.28.tgz"
  sha256 "9346ff31b873b74c2637430eb0fdf4721e69cae05fdcec1c236d47a3771ae5de"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7b482a2e0e42282267590d2ed115da99528bfc76dbf63594dba533e24b8006bf"
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
