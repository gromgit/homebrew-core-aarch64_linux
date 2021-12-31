require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.66.tgz"
  sha256 "a02b23a626e7082d0334a59735f83df48f19f1f1d7c3c538516ddfc9c98e5ae4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6d063167a256dc8b2e82e38ec7bcc3840974a498e7efd524e92dfc8fbe62c68c"
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
