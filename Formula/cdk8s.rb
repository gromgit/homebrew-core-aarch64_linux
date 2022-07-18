require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.54.tgz"
  sha256 "185884972f19ac6b73d03e9a05358455823521379b9f698e3ed9559b2966be34"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7425153b77f1b599ce1ae4bf610e830bd8b520997ff2bf2b017cfe4c1935b3e3"
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
