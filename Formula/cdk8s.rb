require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.58.tgz"
  sha256 "f2fc9874d945a99556f027cc5721ca6118caaea2b2b76255a2b164983c74e629"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e616d7758f6bd07271528d2ad1d0743597dafa3cc943b34b8d6148ae3116ba6b"
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
