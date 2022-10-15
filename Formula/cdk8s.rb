require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.15.tgz"
  sha256 "12237067971c6e833fe161a2250ac503e269b054c08f59055af07c010ac861f4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e25ded54ab4c95a802d37fc2cea15c1256e8a9e8a6c7174c4d2d7f3026f9c474"
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
