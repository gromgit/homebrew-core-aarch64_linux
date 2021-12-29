require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.65.tgz"
  sha256 "9641ddf5421cb4f75afe23980a0e1f01cc22c0e19e90ad38d76f7601c304dc6a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "eaad30214a08218e9a7e22e3075688e81e61244e7001e3da5d29702681202562"
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
