require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.108.1.tgz"
  sha256 "d5347bef2d69820f8fa7829675b2f5535e69e5a69ccdf881cf4c692fa02877c6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "05ceb6aab842c8922ed266dbfd7e6a5294984fb2e4e8f64f3b877826aec3c1e4"
    sha256 cellar: :any_skip_relocation, big_sur:       "69a60ad70a8ebb335e55b5782d91ac72c81c7f98a09f194b95ecf9b06a9f0dd3"
    sha256 cellar: :any_skip_relocation, catalina:      "69a60ad70a8ebb335e55b5782d91ac72c81c7f98a09f194b95ecf9b06a9f0dd3"
    sha256 cellar: :any_skip_relocation, mojave:        "69a60ad70a8ebb335e55b5782d91ac72c81c7f98a09f194b95ecf9b06a9f0dd3"
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
