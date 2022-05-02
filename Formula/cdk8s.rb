require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.164.tgz"
  sha256 "6877b04ec891443021a2cee7a3c3b74d80682414cdb17d242180aced0e660323"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1d14b717c237ed63d85c87594dbf65ddcafdf5edb02ef5cf5ed32f9d649ab153"
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
