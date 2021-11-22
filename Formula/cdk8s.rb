require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.36.tgz"
  sha256 "e289f103ef454b5a0d828d724143a2c3e11ab37287a5741c2fe9ed143f44f394"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b8b7e5b6a331e404df19a90cf33545ec2f93611a064b05b45b15eee28acb48c5"
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
