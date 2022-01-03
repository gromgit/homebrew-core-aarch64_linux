require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.69.tgz"
  sha256 "31b9cb7b02a9f4303a7efd28723a182d31301c2c69ef0cbc79488cf70249d7d9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ee944af56ae554357ce57c850af273ca5751ce461e255e7b94bd5b5c764ecab1"
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
