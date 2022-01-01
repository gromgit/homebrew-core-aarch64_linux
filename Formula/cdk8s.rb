require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.67.tgz"
  sha256 "811f9e537f629b130aa39beffb2e94860be8fc0e23d6bf69273e7c295eb4bb1a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a398f42042cb0c2de185bb5ace8f4de1262eed992d6e545dda0ec8a0556a102d"
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
