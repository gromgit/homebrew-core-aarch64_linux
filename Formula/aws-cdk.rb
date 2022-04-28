require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.22.0.tgz"
  sha256 "d520c9193781f211960446d5edf1e81ef5e6dcbe5c08eb98788cbe89954e4df4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "98ddc265a7976ad91df5948874bd471efc00d8f3575c6b36545e2a0d9b282c0b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "98ddc265a7976ad91df5948874bd471efc00d8f3575c6b36545e2a0d9b282c0b"
    sha256 cellar: :any_skip_relocation, monterey:       "efa4c951926962a1c5675205c243a402122e7fe515f2b0173757864226a1c1b4"
    sha256 cellar: :any_skip_relocation, big_sur:        "efa4c951926962a1c5675205c243a402122e7fe515f2b0173757864226a1c1b4"
    sha256 cellar: :any_skip_relocation, catalina:       "efa4c951926962a1c5675205c243a402122e7fe515f2b0173757864226a1c1b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0aa0916b3485c04ab2a8e8394c098c68d114cdc895bc198632ff4929e7dce611"
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
