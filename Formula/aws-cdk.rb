require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.95.0.tgz"
  sha256 "e68d44305902d4d648b9410ce7ab72869f9525a148150deb76eb61063808aaa1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b1e39c8c185165d4f5c67d68deae3a9ef579fb6c96ea2719ee3df07a26056738"
    sha256 cellar: :any_skip_relocation, big_sur:       "09c41c8dbb58add62212099c2d0bcded89f8ed69abc59081217754b342243886"
    sha256 cellar: :any_skip_relocation, catalina:      "1096b611a8e5a4509ef950f788f932fc56a4fa757a8f6bb92e8d252047c94ff1"
    sha256 cellar: :any_skip_relocation, mojave:        "b6b0e01d4284d7bf5b71e4a6d9d83ce5335614d4145d5c4d4089ac7e222e866c"
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
