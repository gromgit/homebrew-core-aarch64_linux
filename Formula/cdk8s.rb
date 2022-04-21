require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.154.tgz"
  sha256 "3c3730cec864eebe8f383f6f6b137c848bf977823d8688babf2d3b6bfd85a9b1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "93624f981e588eee6e1c8ba575694caf118c9b6f9a5123a678238b55e874852f"
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
