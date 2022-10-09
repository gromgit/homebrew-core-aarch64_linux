require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.9.tgz"
  sha256 "0e0b99a6727436f4599a872c5ba2dca594697f15313c3cddb17b4bd343773101"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3c0322728200bd291acfece271718a95cecc35b759cc856fa40ecfbe1f435904"
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
