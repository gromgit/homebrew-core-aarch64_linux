require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.61.tgz"
  sha256 "98d8946b1bee8650fd97a14d5a99078cf65ea7b32899f81385cc385f2b142d98"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6abb22e6cffb38053b24c8e3b6d415462ab1fc9c80238333248d0262f0141d70"
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
