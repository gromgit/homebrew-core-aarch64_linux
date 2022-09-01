require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.40.0.tgz"
  sha256 "3ebda955effba85659c609ab137f7f8deb30e75409e165c5c3bfa380e4063600"
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
