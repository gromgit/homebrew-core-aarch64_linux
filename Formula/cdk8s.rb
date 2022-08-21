require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.90.tgz"
  sha256 "984cd27ac1d4993afddc3c7277cf763a29c8d3e65bb4671578e19fad7d730b84"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8b74b25e61572f7413ac353c65078d01cc792ebcafa4997ad63bb843356ee746"
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
