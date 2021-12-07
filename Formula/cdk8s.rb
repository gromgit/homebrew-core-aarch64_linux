require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.47.tgz"
  sha256 "905225917d5d0de64fe8bad525fd6825e7bfba0e36a1fb0286731bd6d674c200"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e71a56820c4ce026399126f84eeb3528c221eb67317e0ab7c8f902c4801df2c5"
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
