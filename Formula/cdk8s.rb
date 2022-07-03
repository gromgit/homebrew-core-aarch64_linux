require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.39.tgz"
  sha256 "cf766fe11ce94cb030982df009eb65a8e6aa0ddc536d5fab19c3efca80b5c088"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "aa6313285f53d95b745a31c57d2af4f383665abd10e7833fe996ba0ad019233b"
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
