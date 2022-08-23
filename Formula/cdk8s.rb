require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.92.tgz"
  sha256 "1d65eadd339ac7565cf84d6c184b37ef5fbdf1db221c5933a8d300342905a793"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "15506e96a73049911afd0d506c40e5bbecb1041068b8b9c38fef04b77809165e"
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
