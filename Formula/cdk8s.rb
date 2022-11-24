require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.56.tgz"
  sha256 "18b542e319cd89a7bce3fcb64782df16b073d7ba06c16588bd2c25de5ca7616e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8d77442289434ec965a9d3afe797fd4c9fcf51d212dad1a0d3d4fbd251aa064b"
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
