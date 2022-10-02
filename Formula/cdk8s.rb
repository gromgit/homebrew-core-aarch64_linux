require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.2.tgz"
  sha256 "1ef85a48f01be3cc4e8a4e0a8586327484e5befd2ee8c5b3fcd13a102a5107dc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5cbc69f4dc8862f017da5c7860067833bf995446411ce2bd232a82c9385e4418"
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
