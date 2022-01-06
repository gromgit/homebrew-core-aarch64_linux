require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.71.tgz"
  sha256 "ad771d076fa6fa022e120e8cdb5644492dd198266326e0eb5649576b5069c8c7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7e77f9312b54662b7fccc7e62678e678abfbae623cc9be098c8fd81c93e88dc6"
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
