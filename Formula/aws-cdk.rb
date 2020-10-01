require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.65.0.tgz"
  sha256 "339d419bc95f81028ca42716e845950ec2320fddf232b95563a213d44b46d2a1"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "0d6c33bdb69c904bd371d3fde74821e17b077941dd26f9a1c37b65e45e96a0f9" => :catalina
    sha256 "0445623dbadf4fea1ad75d36951a5eeecd9060e0f1c9c6835da1bf632fe4bb7f" => :mojave
    sha256 "b6ef2973b11c8238a7ca7b95b3dc6a75d344e4d216629bfd27be4eb4ccd2aad9" => :high_sierra
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
