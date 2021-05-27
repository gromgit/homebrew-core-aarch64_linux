require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.106.1.tgz"
  sha256 "ad1f06bd2b864ea0e4a363620d50462ec6317934d492965d9457dc397e99c672"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e68d2e2624c69299b3fed6b9ae01a9fbf7942bb7d74b136bc28a334d1548e658"
    sha256 cellar: :any_skip_relocation, big_sur:       "db6c0ef5effb7232cc11d807f3eab7c2a9992a4191a00bc13536180eaeb2f6e8"
    sha256 cellar: :any_skip_relocation, catalina:      "db6c0ef5effb7232cc11d807f3eab7c2a9992a4191a00bc13536180eaeb2f6e8"
    sha256 cellar: :any_skip_relocation, mojave:        "db6c0ef5effb7232cc11d807f3eab7c2a9992a4191a00bc13536180eaeb2f6e8"
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
