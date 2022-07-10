require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.46.tgz"
  sha256 "42bb88c57fc56b959a2fe79932ef677b549c40f280ff872a1a5f37b1410a26a5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "07640b8262592adee9aa1573af2eb780172eb887e2be2e4ba9b835703a33b70e"
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
