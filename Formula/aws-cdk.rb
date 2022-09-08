require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.41.0.tgz"
  sha256 "0e9939a2f800593899dceb10cb65cbdc5fc46faad41a1d0b29a63047537f27bd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee78c8a6b647cd12f7ed2d81dcc52da09ee95d71d034ff6075f54df0b1c1d199"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ee78c8a6b647cd12f7ed2d81dcc52da09ee95d71d034ff6075f54df0b1c1d199"
    sha256 cellar: :any_skip_relocation, monterey:       "7cb3d8b0a9e9d641203c41f5be1ee02ee103a226b6c964294caa9f52c7229de9"
    sha256 cellar: :any_skip_relocation, big_sur:        "7cb3d8b0a9e9d641203c41f5be1ee02ee103a226b6c964294caa9f52c7229de9"
    sha256 cellar: :any_skip_relocation, catalina:       "7cb3d8b0a9e9d641203c41f5be1ee02ee103a226b6c964294caa9f52c7229de9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be93cd65cb654c390ef159d6dbb3133949e0138aa2c7b55e7e0ede60db16a277"
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
