require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.37.tgz"
  sha256 "a2170e706d72cfb015196678efe10d21ad96596ea1d795cc0e8eb002ecdb8d17"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "66d64cabd7b968810a51faa4335d80b6d7e2f58a5e6e7f5d7b5f553195a62cd7"
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
