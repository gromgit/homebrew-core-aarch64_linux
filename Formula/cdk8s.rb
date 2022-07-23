require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.60.tgz"
  sha256 "8526f93281ce3d061b91ebb6463f429ee0f139dc1baacbd563b0d63cd646c25e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "dc482e93f9d19f2030d80dcd4ffc5e2fa9fe2f9a3507573fc77c67af0e2accac"
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
