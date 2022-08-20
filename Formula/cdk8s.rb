require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.89.tgz"
  sha256 "119b6ef63b3cb23f8d4506777aa3766b3fbd7506798f2e9eb5228237fee89f2e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ca2d11a746510178948fc07c1f92b0ce42e37ddd993220ca88a886aba6ea0875"
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
