require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.1.6.tgz"
  sha256 "eb8e021324a1ef853af39d09bdca59e2bffde8cc3c629613e55460652fda609f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c13f36f68561bbabafffb20d37db428835b52f25eacad898b819b71e397b1a07"
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
