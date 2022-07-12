require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.48.tgz"
  sha256 "686c9bb760f724e65112b493d078e4acd0eeb15eb2107f8986c984940e02225c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "685a0f6bd3ecad339211081678bb6c5de3d00bce71bc87a8fdfd32c43e5fd857"
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
