require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.131.0.tgz"
  sha256 "62c3f42fc33cdbdfd52ec865881a3f845c6470cf23962fdc45c7336c49d112a3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c5118918aeb43b8554b65811d157e6a99a16781165771ef99b6867e5827919d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4c5118918aeb43b8554b65811d157e6a99a16781165771ef99b6867e5827919d"
    sha256 cellar: :any_skip_relocation, monterey:       "7d7f637ca2d5a5ec3da6c37661fb0bb84e4ceec6350d176674eb4cf3386c3741"
    sha256 cellar: :any_skip_relocation, big_sur:        "7d7f637ca2d5a5ec3da6c37661fb0bb84e4ceec6350d176674eb4cf3386c3741"
    sha256 cellar: :any_skip_relocation, catalina:       "7d7f637ca2d5a5ec3da6c37661fb0bb84e4ceec6350d176674eb4cf3386c3741"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73fc67b59ac503a42836e418d68c41b4a020f353ee86e10a0f8dbe27a1a914ca"
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
