require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.73.tgz"
  sha256 "8a79e41db36a5b53e51c6556b81fe0a6048062f2891dccbc47ad546463f5f0a6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "28da75b9db4f803ce53cae48846193253f985c8c2a56286892158148a3e7ad9f"
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
