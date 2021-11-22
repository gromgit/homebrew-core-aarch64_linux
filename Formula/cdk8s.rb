require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.36.tgz"
  sha256 "e289f103ef454b5a0d828d724143a2c3e11ab37287a5741c2fe9ed143f44f394"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1764c8e21569e267468ab264d9c823940afa47554340d3af2b0e593030b6a9b1"
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
