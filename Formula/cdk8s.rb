require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.119.tgz"
  sha256 "5c1d26fbe3b82a0b0b173449069cb79c8904d02bf40b2f28361aeb41a76fe933"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "001f3f5ea4a25956266627a0e276a6ba9554bb8f1007b6d078b2f4729e6f15af"
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
