require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.107.tgz"
  sha256 "f8bea0cea76dbf7b7c57bca32f494bbf0b9368ebec5763ca4371d6e42aa67873"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "eb5e7e72a5ec3be175722ddb201be238caca966b44604e7c97457b3e3f603803"
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
