require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.26.tgz"
  sha256 "e2a1a0cf4bae3cf8f084e358f068db2177fcb0f7a6fa66922150c4ec3c3853d7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c56f0b5b187686765ce601f22cb4411083804672cdbb03522c9f1cbf06e1aa25"
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
