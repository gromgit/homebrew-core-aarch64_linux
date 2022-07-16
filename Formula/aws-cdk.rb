require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.32.1.tgz"
  sha256 "fbda709c3e7332ea238f52058323b2f6f34d57728b3acb132f46dc9913a4146e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "62f77d151ededaa6bdb83193ed1b156cf8e3731706b7cd6f1650c8d146c04a33"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "62f77d151ededaa6bdb83193ed1b156cf8e3731706b7cd6f1650c8d146c04a33"
    sha256 cellar: :any_skip_relocation, monterey:       "3b8ae1ed5b75f1a0fdd062fa5edfd7fea316e2d87704deb2cc94e0fc6010fa0b"
    sha256 cellar: :any_skip_relocation, big_sur:        "3b8ae1ed5b75f1a0fdd062fa5edfd7fea316e2d87704deb2cc94e0fc6010fa0b"
    sha256 cellar: :any_skip_relocation, catalina:       "3b8ae1ed5b75f1a0fdd062fa5edfd7fea316e2d87704deb2cc94e0fc6010fa0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64db8e414145e1f7b621535be5bf5ff5e577d9998b6351aa4a52abaea5865ee4"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Replace universal binaries with native slices.
    deuniversalize_machos
  end

  test do
    # `cdk init` cannot be run in a non-empty directory
    mkdir "testapp" do
      shell_output("#{bin}/cdk init app --language=javascript")
      list = shell_output("#{bin}/cdk list")
      cdkversion = shell_output("#{bin}/cdk --version")
      assert_match "TestappStack", list
      assert_match version.to_s, cdkversion
    end
  end
end
