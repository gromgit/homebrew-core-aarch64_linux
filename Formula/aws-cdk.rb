require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.27.0.tgz"
  sha256 "0b8213d2bdde788a802f4c59849fe48ef1f6427456cd3b1b7f7599c6bab6eea8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db8dee8fa94634ef072bd9c88c9b6e7f7dd79426d8f6ac45f7aa2c82f658eab4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "db8dee8fa94634ef072bd9c88c9b6e7f7dd79426d8f6ac45f7aa2c82f658eab4"
    sha256 cellar: :any_skip_relocation, monterey:       "b30fdbac5645c33f5573bfcdc8e2ab9107fde36df087819da03a0bdfb002e9d5"
    sha256 cellar: :any_skip_relocation, big_sur:        "b30fdbac5645c33f5573bfcdc8e2ab9107fde36df087819da03a0bdfb002e9d5"
    sha256 cellar: :any_skip_relocation, catalina:       "b30fdbac5645c33f5573bfcdc8e2ab9107fde36df087819da03a0bdfb002e9d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "959b03ac8cf294203058c391797282c05e637fef51b2af4a94b6693c0d697f98"
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
