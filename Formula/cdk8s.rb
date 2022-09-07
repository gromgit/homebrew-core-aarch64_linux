require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.104.tgz"
  sha256 "1f6fda88913c8100fb7c9d951da1056c31030a9373b6875bdb482f2b9d2a3ec2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bf5bfeb3ca5e4581131c527692495f3022b627331a31617ea345d083fd6b9001"
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
