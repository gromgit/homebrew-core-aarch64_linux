require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.96.0.tgz"
  sha256 "38b9cbfa59af29f9f376753d143ebaabfbb28c268dbd2f02def7c1ce708cc901"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5d089e661ea08e60bb7237e798d43f2e5f5679695f8899516ef70338d84be6d4"
    sha256 cellar: :any_skip_relocation, big_sur:       "617d37413cd95644b6ee22d2272f2b861f6ba1f2a0420b7c681e099876fa014f"
    sha256 cellar: :any_skip_relocation, catalina:      "11acae891ca0ca147833db167204c3c1d050c940127982000f5182c386d5bf4e"
    sha256 cellar: :any_skip_relocation, mojave:        "9e7adf58e2775181b6e7d1b286b4c1a30cbf0bbd1eb27b4f100050cc4fa7dce5"
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
