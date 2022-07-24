require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.61.tgz"
  sha256 "0366a02087e53466353f8702866a2a11e896174ff412a79759dfe0c5ec334150"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "66157bf78b72309f1d68886e0a63d071df777308fd9f0b03db43a019ef265b91"
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
