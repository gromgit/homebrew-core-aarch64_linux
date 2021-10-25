require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.13.tgz"
  sha256 "97bda9900dc64262f354d93bd90c718001f9dbe0438f37a64d4015e96da7ebc7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "87eabdfd4fe822ab95caa1dd4f01dbd9a2276233a6e19a021aba4f98c7fc63a0"
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
