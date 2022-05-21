require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.1.4.tgz"
  sha256 "92c8d7255612e8039d334f23d28d99a1c680801afccf12adc0282a91a9de2539"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5fbad141f8a741ad44b96bbb2cc3660488d8af7783bce37b2b5153743d05f6ab"
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
