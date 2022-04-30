require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.162.tgz"
  sha256 "1797dd3fdbdbebf8eb5c61793d2591a74e661d52cbf3bea5194612918ead65ff"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "513df9dac436669b70b64da62283fd42838cd28db975c43adeb7d48d2e544a2d"
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
