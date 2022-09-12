require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.109.tgz"
  sha256 "c1b114ae31e2043096d59ea2849ba7e65dbfb555983edf68e5f503c6a75a9141"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "02a91f29d62473084dc1facf5adc0bb5b39a7eccba6fdb565f0a1737e8169f40"
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
