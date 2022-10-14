require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.14.tgz"
  sha256 "e67a4dc530c7d8cae5cab7a847c64fe2097f695c365912aec35395a2b872ae05"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5ef8d9f6f6ec195f7ef6d16b041afae82acdd42d6c5105e5372f323e1dda8c38"
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
