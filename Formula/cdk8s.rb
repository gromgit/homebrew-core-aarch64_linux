require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.75.tgz"
  sha256 "b124f161f4ed6dcbae009e5e3f40c2eda649b884748f77af1329978dfea387fc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6f4b655d93f6251c7ecb0d9a1b4c3ac197b2bd1fff036c8a6627bb887b606941"
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
