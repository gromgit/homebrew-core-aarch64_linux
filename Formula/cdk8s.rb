require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.36.tgz"
  sha256 "6ebc4990598c6b4272903fa4ba75fa80845a04790a73501409cadf1eedef7c14"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b02dc6a0120e5a7f9360be2631997090107b2c3f8c72ccbb080b8529a0685223"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b02dc6a0120e5a7f9360be2631997090107b2c3f8c72ccbb080b8529a0685223"
    sha256 cellar: :any_skip_relocation, monterey:       "e45b9a344467d85a64f3ed30afcdb5309b34f657534324b579e112b4b5ac27ed"
    sha256 cellar: :any_skip_relocation, big_sur:        "e45b9a344467d85a64f3ed30afcdb5309b34f657534324b579e112b4b5ac27ed"
    sha256 cellar: :any_skip_relocation, catalina:       "4d3e2010b30693a9b7339ec2942d0402c02aefaab73c47ce5bb8db0cab523134"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b02dc6a0120e5a7f9360be2631997090107b2c3f8c72ccbb080b8529a0685223"
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
