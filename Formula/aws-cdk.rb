require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.113.0.tgz"
  sha256 "8eaa24ade568bd0b9ac4be7293c77bcafb1b73ee04bb8ea4cf3dd60207e429ad"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4b9148465b2d36a48b5d160d5c07afcb68b1a8758f6c94d8ad2237a92bf60f8e"
    sha256 cellar: :any_skip_relocation, big_sur:       "d51e49231840ef9045abbf8a3a09ac89ff8dd511300e72e2e4d9f79fb5d6c057"
    sha256 cellar: :any_skip_relocation, catalina:      "d51e49231840ef9045abbf8a3a09ac89ff8dd511300e72e2e4d9f79fb5d6c057"
    sha256 cellar: :any_skip_relocation, mojave:        "d51e49231840ef9045abbf8a3a09ac89ff8dd511300e72e2e4d9f79fb5d6c057"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9632e0248fb3854d60e659ddbd42dd12584b7bd74e0a45d569763d0b592b5687"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
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
