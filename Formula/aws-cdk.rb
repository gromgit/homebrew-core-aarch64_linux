require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.56.0.tgz"
  sha256 "658855e5749723bc35d07afb78f9308df9f4793987be2558c7374bb92cdb1825"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "6a40b81261d925025161c45c89f3f8ceb09ef29796e523c5877455eaf7e8ccf2" => :catalina
    sha256 "19630499bab57bce051a7dfd365ca943892178f4b6a6e66f9bd7370a1a5bc897" => :mojave
    sha256 "48118fed2d5f891bc9895217f4364b678b9f20991473fb4e4d1f4313c75e8838" => :high_sierra
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
