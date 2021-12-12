require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.51.tgz"
  sha256 "5d0656e64ca846ab04f481528158670b838fbe9916e66de21a3a65e04c19e359"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "67a073d56684c1bec02f7966689290812c29f597f5c0d99d218f9e70d2447e64"
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
