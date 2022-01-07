require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.4.0.tgz"
  sha256 "38ec1efe745a3e92629195c352182b6833dbc3c5f718dfa5d1e85ab9a1870a61"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f5d82636e6c2fa5f28daba5ed88704880fbb694b3b9f5f6e24e388e24287036"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7f5d82636e6c2fa5f28daba5ed88704880fbb694b3b9f5f6e24e388e24287036"
    sha256 cellar: :any_skip_relocation, monterey:       "24eab0d3d342be985a49077d9b055ddfb942ad65f6175fd7b48eb96d540c3bd3"
    sha256 cellar: :any_skip_relocation, big_sur:        "24eab0d3d342be985a49077d9b055ddfb942ad65f6175fd7b48eb96d540c3bd3"
    sha256 cellar: :any_skip_relocation, catalina:       "24eab0d3d342be985a49077d9b055ddfb942ad65f6175fd7b48eb96d540c3bd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52d5e5c22c9ef2f3cb9d29b339278728b33a504b481ee0e70094c33c75b40a01"
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
