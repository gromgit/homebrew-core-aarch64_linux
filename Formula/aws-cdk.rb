require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.59.0.tgz"
  sha256 "18664992efccda51e45f04bdee445570a4d2c21aa7d1a9172604d3bfe3d96fe0"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "c005e5ba14ed4435392d62770364a54d493ac0f9ca5259f2c555803e373873e8" => :catalina
    sha256 "be1ecd0dbbd84f6b1e515ba7bf237ef62c544ca994b57429972fb665a32c2817" => :mojave
    sha256 "79344ffbaf2f6c2615f95fafe726941b25e4bb6133e35c71758c5a97f75def06" => :high_sierra
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
