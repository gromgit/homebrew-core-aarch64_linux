require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.23.tgz"
  sha256 "fb4474e95a5fe82a5269bb576dd18b4d4d63b78d2853b9f98994f6ba1ba3ba1a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0e8c7d526aa3b5ed79e5421e8e0e5a0a4a2b618e1c860901c2578c393e4a111d"
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
