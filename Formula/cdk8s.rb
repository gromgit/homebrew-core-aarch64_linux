require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.79.tgz"
  sha256 "bd0fab46d4a002043c3cd5e85bab5af359bcb821b8521e17a5331f257382d02d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2c802a2567eb761ddd38855a752e3ee05f9720731c40c864ac33b65eb2d2a1e1"
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
