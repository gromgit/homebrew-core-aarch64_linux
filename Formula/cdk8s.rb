require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.69.tgz"
  sha256 "76ff959365081ab96b32a307886d6d4e9c6ac5401582df66fd1006e8a3b087f0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "27d89b748ccc221e6a6ca58e2eedb47c1c204896d01e599c6981f0cacd79e434"
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
