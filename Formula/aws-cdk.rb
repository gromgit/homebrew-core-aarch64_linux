require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.7.0.tgz"
  sha256 "f859d4ef25cfab605a8196cbf5f96f5eeabdbe62a98e91345e23296c588865f2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e4e17f6b6436893832e35db4a39c0a7d495d500b7a983352371e852b9fda23d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5e4e17f6b6436893832e35db4a39c0a7d495d500b7a983352371e852b9fda23d"
    sha256 cellar: :any_skip_relocation, monterey:       "0da9717b7889c93b69a5e9512313aed80f58d8a0e279d54ebc68814ed79ac636"
    sha256 cellar: :any_skip_relocation, big_sur:        "0da9717b7889c93b69a5e9512313aed80f58d8a0e279d54ebc68814ed79ac636"
    sha256 cellar: :any_skip_relocation, catalina:       "0da9717b7889c93b69a5e9512313aed80f58d8a0e279d54ebc68814ed79ac636"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "abb1d4afa638c9e264c71e83e7c0ae87516dea4418f4f912a71f78dddc483fdd"
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
