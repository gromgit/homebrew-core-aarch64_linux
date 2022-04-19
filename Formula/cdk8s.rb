require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.152.tgz"
  sha256 "e9ed350e9c78b50ddede8a4f758ac7ab6a037f700ea8d39315a55d3e93e4210e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "16a49d34b249315612924890f31c0ef9715c83987211ea8c9f6ee3b0720a8ec8"
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
