require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.39.0.tgz"
  sha256 "ae990dc06719fa5593131a50e0e836520b9214bb2ab3deeb0758d806c66a859b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2dc24c2233237fe58141e435198b2aad0349fa3f92b3f56836c82f39a4243daa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2dc24c2233237fe58141e435198b2aad0349fa3f92b3f56836c82f39a4243daa"
    sha256 cellar: :any_skip_relocation, monterey:       "226161e5ae43d12a0ffb01bcdab0a5b9a987b5bd1827ae3798614272c1d9801a"
    sha256 cellar: :any_skip_relocation, big_sur:        "226161e5ae43d12a0ffb01bcdab0a5b9a987b5bd1827ae3798614272c1d9801a"
    sha256 cellar: :any_skip_relocation, catalina:       "226161e5ae43d12a0ffb01bcdab0a5b9a987b5bd1827ae3798614272c1d9801a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0810c319501bfdb8dbfdcbdf05ece4479d6cc8ad462c69ecfcde034b16043014"
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
