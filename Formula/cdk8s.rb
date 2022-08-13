require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.82.tgz"
  sha256 "e29af0e41abfc6c9ef33bc24bce7ff01448960e8382bc436c6c207ec8cd089d6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6d280ed81b5710fb89e3131be4cc2014c4218071e842ef7423fdd90f11a29a3c"
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
