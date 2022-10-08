require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.8.tgz"
  sha256 "6b9b7be13e056e12248f60789a654fe0a51695a04f300b2236bb44ded43423d0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9fd2257dc7f3747c9e91afa2f0d08dd9a54f6dac130b0444bd9c4875261e8aac"
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
