require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.32.1.tgz"
  sha256 "fbda709c3e7332ea238f52058323b2f6f34d57728b3acb132f46dc9913a4146e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c60a1271d6b04f66771c5636272ff420161d7f6ad87952d89b0917f7dc2eaad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1c60a1271d6b04f66771c5636272ff420161d7f6ad87952d89b0917f7dc2eaad"
    sha256 cellar: :any_skip_relocation, monterey:       "71409b33357507194dc74b103a4772816d250c90cf992ee2c5f687c1e7205bf7"
    sha256 cellar: :any_skip_relocation, big_sur:        "71409b33357507194dc74b103a4772816d250c90cf992ee2c5f687c1e7205bf7"
    sha256 cellar: :any_skip_relocation, catalina:       "71409b33357507194dc74b103a4772816d250c90cf992ee2c5f687c1e7205bf7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86acfb43743537c9339e34249458a3214f7cde01f22e677ba6a8d348f0e6e739"
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
