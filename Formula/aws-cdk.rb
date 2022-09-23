require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.43.1.tgz"
  sha256 "36750570a60fe0bed4960c5ebc85cb4367ed964801cb7d816995de956edbed10"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "18cd436deaa7c5d9a8f865c13f365af305938c86f494c49b68b8550c9d953fae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "18cd436deaa7c5d9a8f865c13f365af305938c86f494c49b68b8550c9d953fae"
    sha256 cellar: :any_skip_relocation, monterey:       "3f2b2d7bfe7d7f220a41b51d5f83c37d0fa2a033d9360712908a5ff292906313"
    sha256 cellar: :any_skip_relocation, big_sur:        "3f2b2d7bfe7d7f220a41b51d5f83c37d0fa2a033d9360712908a5ff292906313"
    sha256 cellar: :any_skip_relocation, catalina:       "3f2b2d7bfe7d7f220a41b51d5f83c37d0fa2a033d9360712908a5ff292906313"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7c9a5e3a5daacbf0d66da39e4afa52d07f8654bd37847757bfccd1a3bddb773"
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
