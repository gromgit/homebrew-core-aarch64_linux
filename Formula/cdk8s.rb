require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.96.tgz"
  sha256 "2ab44e2968e4ee40b4066ddd34410cbee169892cfeea010e16449d3d0658337e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4f1410a2396ddc62aff7c1cd711c012d8d1090c32578bfb208c80a24d7448a52"
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
