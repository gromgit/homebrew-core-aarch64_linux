require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.98.tgz"
  sha256 "06325f89bca52ac2117bcfbd5f59ec16c791a8958395ed265bdcf83fe89ea5c6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c7ccfdee81cb13e7dd9423d610e0e38f797a7914368840dbcb89514984b51a76"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c7ccfdee81cb13e7dd9423d610e0e38f797a7914368840dbcb89514984b51a76"
    sha256 cellar: :any_skip_relocation, monterey:       "b5ff541193288b2ea298173ef6d695ef202450a49155e19e118440949fa2266d"
    sha256 cellar: :any_skip_relocation, big_sur:        "b5ff541193288b2ea298173ef6d695ef202450a49155e19e118440949fa2266d"
    sha256 cellar: :any_skip_relocation, catalina:       "b5ff541193288b2ea298173ef6d695ef202450a49155e19e118440949fa2266d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7ccfdee81cb13e7dd9423d610e0e38f797a7914368840dbcb89514984b51a76"
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
