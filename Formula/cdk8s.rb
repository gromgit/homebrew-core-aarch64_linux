require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.3.tgz"
  sha256 "da219d001af7d99ce4478c6f05df8f8f549355896d813cfae2f239e167a40486"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "975678f3d7d44879851a84d90838b02621e011b41d56bd4699d13e57dd7969b7"
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
