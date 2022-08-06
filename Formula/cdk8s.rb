require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.75.tgz"
  sha256 "b124f161f4ed6dcbae009e5e3f40c2eda649b884748f77af1329978dfea387fc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3d1d3e65d23b8f33c2a843f5394a004bc4683314fc273ce77c477e2f897b1ffb"
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
