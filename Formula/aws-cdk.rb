require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.23.0.tgz"
  sha256 "6fe89bb4d6d1ef0474eecb047e464ffeee6c5117fb93710401192e018e942865"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "59fd28d8a0653d90c269b95aed71321ba7525211d9ac8f068ae37e1792abc259"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "59fd28d8a0653d90c269b95aed71321ba7525211d9ac8f068ae37e1792abc259"
    sha256 cellar: :any_skip_relocation, monterey:       "715b6b57150721421e2965cbf701f3d975a6ad5f461b31c7e50468686da79bfb"
    sha256 cellar: :any_skip_relocation, big_sur:        "715b6b57150721421e2965cbf701f3d975a6ad5f461b31c7e50468686da79bfb"
    sha256 cellar: :any_skip_relocation, catalina:       "715b6b57150721421e2965cbf701f3d975a6ad5f461b31c7e50468686da79bfb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "628f505c3b0dd19790309d79ee7820af1129d3206228315ba4a339f49382ecc2"
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
