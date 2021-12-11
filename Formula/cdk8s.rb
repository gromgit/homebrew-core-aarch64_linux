require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.50.tgz"
  sha256 "9d742016f6ec1d368f736b10f766b5bcc8534220172ef119657f73913297192b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "72a89ded77ba6cd2082c9dd4d5ddce2a96325e6ce7708381ecf5d55050bd4a65"
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
