require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.122.tgz"
  sha256 "4f8d20975eb0e0d595a0b570fe5db54fa5eed1c4a91331ef5ceb891b4842573d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e4cc9bd6a04caa41d21ee2f70fbe9aabd9fb5b184c58e82bd26514dad6af78ca"
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
