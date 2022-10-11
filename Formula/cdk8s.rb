require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.11.tgz"
  sha256 "5b8bf25d625836a04586ae193f6581ab450036351c1482eb9fca6f2cd27f4ae5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9f02393955464bdc861605918c5897a94fd0284a3617afc25000934adffbcc0e"
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
