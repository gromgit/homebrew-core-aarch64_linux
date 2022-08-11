require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.80.tgz"
  sha256 "dbe4e16d90bae8e9ecab5a08e4afb68ada99bbdd1c26c0c51dc2cca83942282f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ab7613285a17da4164ec6d41d3b84713ba09a6da2e5ccd0cf6c5233b2b256a51"
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
