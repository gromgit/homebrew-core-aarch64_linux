require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.84.tgz"
  sha256 "88ea2478081a59026e5e7e2460d1ee7ac082bfc8d9b35c446d1015bee7383dfe"
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
