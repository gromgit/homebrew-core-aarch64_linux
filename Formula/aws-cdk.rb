require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.102.0.tgz"
  sha256 "09aa219a1f087526c0ea97b81e30f17861218a3dce8f17bee184bcf06bbec70e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6896688659644c69aea7e1b676c5acdd709895a50f535e275246696137ffbea7"
    sha256 cellar: :any_skip_relocation, big_sur:       "53d9fd6c9a486fd42567c4ac22f08d4886348de347b2c76cefa59a09f25a465d"
    sha256 cellar: :any_skip_relocation, catalina:      "53d9fd6c9a486fd42567c4ac22f08d4886348de347b2c76cefa59a09f25a465d"
    sha256 cellar: :any_skip_relocation, mojave:        "53d9fd6c9a486fd42567c4ac22f08d4886348de347b2c76cefa59a09f25a465d"
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
