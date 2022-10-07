require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.7.tgz"
  sha256 "fc71dc736f7b83fd6e0152f16306b667cc09dbea733408d66f910ae463e748df"
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
