require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.68.tgz"
  sha256 "3ff954d93438e10ee0bb1ee26d1ccdef00cff60f3b0b4100080d659ecc0201c8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4b7bd3711dcf2a82f0e84aa5a8694b4f0cf553ff58808d9d46133cd914151568"
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
