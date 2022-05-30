require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.5.tgz"
  sha256 "2c70a07b2ad0f11044196e2e6b1851e3b54b306f19acbcc906434f6acc469c30"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7e2baa367d9f131a8276ef47bd9a2a45034e43f73ed3dc82ecc0be03d1b75b76"
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
