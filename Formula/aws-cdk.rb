require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.58.0.tgz"
  sha256 "792d7fa7eacd7df7583cf275191eb1515894981663a0754dc6553fa0e4959207"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "f109ebcd63a90fdcc1ba19bb0a4acb3691d5ae9642cd7dfd1871506442ffa6d7" => :catalina
    sha256 "2183258146f9d64decbe59de93c428708b3268587ed41516df24b0a24fd397a4" => :mojave
    sha256 "c8b3b2fb9b1d3ec5fbeccdc55166fbfc30e298688ea51e22026e7250673e78c7" => :high_sierra
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
