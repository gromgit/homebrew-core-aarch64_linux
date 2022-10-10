require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.10.tgz"
  sha256 "a7201b080153b41750611b7958e2ea23f1b59d99ccaed3e378a6719a378bdb70"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6ed0dd8a7e4500c81bc4b80b9e28c68bada1cd06752e5b095b9d9618ca5207b5"
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
