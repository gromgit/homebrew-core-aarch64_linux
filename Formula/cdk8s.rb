require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.111.tgz"
  sha256 "3782ceb10e1f681eab86050e97395d4b3069463e4f920324c3de137748c1b3de"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2d1a6e535d697fd53787e198e1da029bb073aad21a6f32920e65d17aefdb45ba"
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
