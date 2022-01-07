require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.4.0.tgz"
  sha256 "38ec1efe745a3e92629195c352182b6833dbc3c5f718dfa5d1e85ab9a1870a61"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b94708074b857dbe572d928e027d7e0fd08f30c6699355660ae744a46b8a6259"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b94708074b857dbe572d928e027d7e0fd08f30c6699355660ae744a46b8a6259"
    sha256 cellar: :any_skip_relocation, monterey:       "17e3064c50d2f477ab4ee808da63913cf00097c431aff4798f51ff8a414de005"
    sha256 cellar: :any_skip_relocation, big_sur:        "17e3064c50d2f477ab4ee808da63913cf00097c431aff4798f51ff8a414de005"
    sha256 cellar: :any_skip_relocation, catalina:       "17e3064c50d2f477ab4ee808da63913cf00097c431aff4798f51ff8a414de005"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e96ad206aa38ded728ce602de575a9b5396b2f6380cad53c76272de335d8275"
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
