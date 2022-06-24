require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.30.tgz"
  sha256 "746bfe3b4e99b34044d702b0c3ffc5d3143a6d572df93750dbcd500ff7876fd1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c479e0cf8c90a839bbba052d1304283df0f85a83e23e3c276219da588490d4c5"
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
