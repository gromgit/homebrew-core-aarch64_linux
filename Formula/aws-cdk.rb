require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.94.1.tgz"
  sha256 "b8fd6422f834d8331665ed68e0e099375ff451c7a0f78e3eb23c1b85ce95ed28"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ae28be16d4ee145540f656a990c81cfd906b099bae05c94ff6ae250c88854de8"
    sha256 cellar: :any_skip_relocation, big_sur:       "bd2b1d0602f0e00c499dde78dcefce2831f22c2d7e69019b278dcf6cc28b3291"
    sha256 cellar: :any_skip_relocation, catalina:      "1c1cee3c33c828c3b637fc201f3f3fd50d88d511afcdef7884c9b66873323d46"
    sha256 cellar: :any_skip_relocation, mojave:        "77862dd7c8536637151bb40b551e2f7d2566b92ad023fde2fc2dba3045685bb3"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
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
