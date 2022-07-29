require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.34.1.tgz"
  sha256 "ff7d9bcce228453e05923406189cfe0e2152b4a4fb4a2fdc2dced5be8c285fac"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a71863682ee2b9a40a1254a9439a8cf727fbbbab6bf4524b39fdd78ad9908666"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a71863682ee2b9a40a1254a9439a8cf727fbbbab6bf4524b39fdd78ad9908666"
    sha256 cellar: :any_skip_relocation, monterey:       "5c118dc8bfb2c27db8973c8a2739a7199993d9de074b674c62f8ee0a97222bf7"
    sha256 cellar: :any_skip_relocation, big_sur:        "5c118dc8bfb2c27db8973c8a2739a7199993d9de074b674c62f8ee0a97222bf7"
    sha256 cellar: :any_skip_relocation, catalina:       "5c118dc8bfb2c27db8973c8a2739a7199993d9de074b674c62f8ee0a97222bf7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "682a37e662709487ebedbd3b35b2e3454b904a073fa6f13da97277ec8a7b3421"
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
