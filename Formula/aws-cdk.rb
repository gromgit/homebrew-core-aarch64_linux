require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.104.0.tgz"
  sha256 "830bc2cdaf3b18ccbaff15157070982b42074db373f183c27525cccf85906474"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "95b7b55c591f0e9b4208af50935ebc89bdbcf8aba64f07ccce94d4f355558a4c"
    sha256 cellar: :any_skip_relocation, big_sur:       "82d7b4eaaf86494ca1105c4ae9919e323c0057d123ac811569c87e2d817c4ed0"
    sha256 cellar: :any_skip_relocation, catalina:      "82d7b4eaaf86494ca1105c4ae9919e323c0057d123ac811569c87e2d817c4ed0"
    sha256 cellar: :any_skip_relocation, mojave:        "82d7b4eaaf86494ca1105c4ae9919e323c0057d123ac811569c87e2d817c4ed0"
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
