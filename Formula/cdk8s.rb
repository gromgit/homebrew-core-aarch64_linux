require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.123.tgz"
  sha256 "c85028ba427a6ad81c38e6d344e84a16b2c82fabac666cac998c7f7eec53e088"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3cab77936c6e281dd0173521514cedd49daea2f4111a9689bb2675fa0f9ccb86"
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
