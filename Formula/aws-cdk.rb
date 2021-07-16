require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.114.0.tgz"
  sha256 "f96f19aef84431ed26618a02dc1d0bfd4aa0aaa45b0f27a23e18813b6ad8a077"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9a17a722f79dcf6e493488772d4ad98f6bce53b6a80cb366cfab130c6db5d6b2"
    sha256 cellar: :any_skip_relocation, big_sur:       "bd1a16dfbb02963231411c95f46788764d5a05c384630283bcdbe8ba6d4d47ae"
    sha256 cellar: :any_skip_relocation, catalina:      "bd1a16dfbb02963231411c95f46788764d5a05c384630283bcdbe8ba6d4d47ae"
    sha256 cellar: :any_skip_relocation, mojave:        "bd1a16dfbb02963231411c95f46788764d5a05c384630283bcdbe8ba6d4d47ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a17a722f79dcf6e493488772d4ad98f6bce53b6a80cb366cfab130c6db5d6b2"
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
