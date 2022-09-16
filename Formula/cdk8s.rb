require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.112.tgz"
  sha256 "718315fa822d57f904c56cabca54a6df208e471fb95e4f3a601f351f8dcd5d77"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "923fba77022febdd22d15c175ae266eea675f36d33b1798eb189027a6bd3a8ec"
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
