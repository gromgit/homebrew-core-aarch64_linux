require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.46.tgz"
  sha256 "42bb88c57fc56b959a2fe79932ef677b549c40f280ff872a1a5f37b1410a26a5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "04e9db6e37e10459b1f89dee0a5b4ed3be8f12913180ff0a2e2468add45a7d8a"
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
