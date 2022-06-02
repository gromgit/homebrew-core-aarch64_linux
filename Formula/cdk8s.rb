require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.8.tgz"
  sha256 "a3afddb958f5d71f4e29cb485ee79047a8cce1f3aeac3183a89b9f490f54a12a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "37273d18f1a22d5b2aa45040358d6dbd73e11cd57cc0c2ef53542e2c5b762b52"
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
