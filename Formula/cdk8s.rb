require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.53.tgz"
  sha256 "aae210b9247c53eeaae474110521788bd07ce61e7b8854ab1ea601fb8ee95fde"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e9236118c0a56b47f9cdefb1a2835caf6843801ec705bc447988af664d0e5d8f"
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
