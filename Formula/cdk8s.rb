require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.11.tgz"
  sha256 "ba6c8097a6a958187ffb43ccff5e6a1975a4a2322aba9787e3732393a6ae314e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4b1b91d3611a16e006688e36252c5ae0bee39b1ddf0d8e691e5219c3c0e3c84c"
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
