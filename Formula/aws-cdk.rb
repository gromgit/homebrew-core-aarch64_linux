require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.42.0.tgz"
  sha256 "a413c8b36c85b988c253053b354fc7c7655d84087bb3a17dfc71e30748393d9c"

  bottle do
    cellar :any_skip_relocation
    sha256 "87358c7e99f71b541c4b09e7eba16c9fd8a97b41c206c7d85d9b5308d20015f7" => :catalina
    sha256 "9f2639df87a7abdd23b74a176f141ad3de9d00be7d34d665afd39d1bd8954ebc" => :mojave
    sha256 "a8a00098407dc2e58d92bb2a3171c55a358db5909511820e6d12ffc7c07150b9" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    mkdir "testapp"
    cd testpath/"testapp"
    shell_output("#{bin}/cdk init app --language=javascript")
    list = shell_output("#{bin}/cdk list")
    cdkversion = shell_output("#{bin}/cdk --version")
    assert_match "TestappStack", list
    assert_match version.to_s, cdkversion
  end
end
