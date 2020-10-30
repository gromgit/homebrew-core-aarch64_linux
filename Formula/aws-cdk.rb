require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.71.0.tgz"
  sha256 "155ba1aec0eeae3b14942c7698613303568c39a9ac4148eee563ea3bdb5de7b8"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "151348835ad404c960206b0b78c835cde9b88788de6378b1ffc8777ff7e030aa" => :catalina
    sha256 "2f73f78ef59cd9c234d4fa67ae3a7b1d6d5c9e1fcb3ac50dacbe18caed86bf02" => :mojave
    sha256 "83da20379e233adb1b28f98d5a33d07485d1a03798b5c291afcb31374c6d01fd" => :high_sierra
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
