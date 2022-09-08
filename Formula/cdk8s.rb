require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.105.tgz"
  sha256 "71eca6ceb66f917c9ffc088d5704072a7886587fcf20ad20da08b79759c47502"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0f8929a049e6e712f60be4b2bb7bcb5a113484892b7cbd6378cb3394626f2276"
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
