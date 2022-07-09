require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.45.tgz"
  sha256 "c5bad18e005d16b45e3e1b7fed8e9fff650d502fc761bf8c12376c2d60701d38"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f8f32f8d8af47bfd2c97cab7600138c013754663aef2376a59d9d225058f0270"
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
