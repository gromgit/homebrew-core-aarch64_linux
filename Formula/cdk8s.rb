require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.64.tgz"
  sha256 "c082008604a6773fa0898f225b0d4448801b998c482a5ab845e02f0e6a3627ba"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1c88a5227219b455a5fa2088cb20129f4884956d706a6eee838ffaa429e31bcb"
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
