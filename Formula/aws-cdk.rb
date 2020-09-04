require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.62.0.tgz"
  sha256 "1b980528363dc624b881fe19f4b2782d814d78c493bda770f4555627c512bf50"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "5ded5697d1597b2cb0f5a3acad80f064dc2a978a9fda08ba9265660386968cc9" => :catalina
    sha256 "2061815ce75576fc2f571f868bc3e5fede35895f14bd26001ea4b2e229e5b6fc" => :mojave
    sha256 "9c643d74fd5069fff14f99ba78537889758a859efe7f72908b034c726ae502c7" => :high_sierra
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
