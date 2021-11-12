require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.27.tgz"
  sha256 "9cd2e07b2f849a151938fa3517681488b9687ea5a9070955578e061b397b0931"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a0c786e404480e6278822fbf95feab685f8c42a1529233799542a1f39517a63a"
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
