require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.9.tgz"
  sha256 "736297d3ced8510821f53c95834a9c226d53a1b089a955f0b8ccb147d24a21da"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c29ada5a0a5a1d3263700733152de8bed9ae90071c28814525b0418773ed8ea0"
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
