require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.83.tgz"
  sha256 "3295e8feab12beafd03c3d1bde9eb70deeef50e717b03e4b8d9edf658a44fa2b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e1d6e2943947e87d765ae8079c1da8c1bc49d260971b6f9f866c591410a6f7d1"
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
