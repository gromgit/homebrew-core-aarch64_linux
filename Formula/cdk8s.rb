require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.158.tgz"
  sha256 "faf2cb080c8cf4e2195c2e43d2b18a7345e5dc178ef707679893b9c07eec6047"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b8d9353dfd97c9a2955d3774cc6a7d385b31798cb2a42c98ff4a56cbc48439af"
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
