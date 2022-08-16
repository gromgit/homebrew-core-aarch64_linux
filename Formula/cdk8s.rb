require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.85.tgz"
  sha256 "09fc2561be8fdee09bc1b76b357f79b34f9978c2b757b09b68ca6a5c0cb40e6b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ef80d47629ec8a8f5ebd77ef5cc731a86ceea9efcefab1e5dff796bd6aec7cef"
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
