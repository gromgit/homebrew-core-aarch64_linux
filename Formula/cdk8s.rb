require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.57.tgz"
  sha256 "69c5f8ac16caac121e242f51344474d2a5f0c0b68a95673c243366a97fb9ee01"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "52e9998d3304eeaa437acc341694c86968accb490c9d36acf683e0459a58616a"
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
