require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.111.tgz"
  sha256 "3782ceb10e1f681eab86050e97395d4b3069463e4f920324c3de137748c1b3de"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1a90438309e1422144e87c6539d6346b40da18709208714f7b3a24cb6132861d"
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
