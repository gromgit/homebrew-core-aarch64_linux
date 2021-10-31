require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.19.tgz"
  sha256 "f71f45cc9bb990c3a97c7f50d5662b5a11871e7e267eebd5aeac3a306de8f29a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d074e14c3fec3f7c6c61836ef4d993675840fd7550871e07156d1f7edd69ff58"
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
