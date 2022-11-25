require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.57.tgz"
  sha256 "69c5f8ac16caac121e242f51344474d2a5f0c0b68a95673c243366a97fb9ee01"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8d77442289434ec965a9d3afe797fd4c9fcf51d212dad1a0d3d4fbd251aa064b"
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
