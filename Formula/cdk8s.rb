require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.10.tgz"
  sha256 "be84301e1e3f801f3e7f37f0d2dd46d4c4d545314b2bb62a3392b44bda45b031"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e5672ea86adfce65f29b4ad06e8e727016f8f651350f4db18450aeb01e003949"
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
