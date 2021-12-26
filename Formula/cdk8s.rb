require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.62.tgz"
  sha256 "d7e6a518e27e61bffa960dc12d7c1f8b1204da2b325f02c4e99472d92964f700"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1c88a5227219b455a5fa2088cb20129f4884956d706a6eee838ffaa429e31bcb"
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
