require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.100.tgz"
  sha256 "dde512d235b35069c470dd91cd3b69966b1ae7c9a3ae3978b5567445b193ba62"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "34606da52ba8d5807908fff2c380bcbefb81aea18670bd0f710adbb2beab9d0e"
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
