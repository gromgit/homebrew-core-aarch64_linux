require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.59.tgz"
  sha256 "f2fc46cb8949aea61f2e5e85ca1f6ca67fc63d81d3e80922d979ac313c0d2564"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "87e493e8715fd65a27b113f2d7613382f3bd523bb74814172988f6504d757c8e"
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
