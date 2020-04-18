require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.33.0.tgz"
  sha256 "9eb1c7f0b51611efa9b3e006edf37b954b2d9006282a9384a0591e180c0bf3dd"

  bottle do
    cellar :any_skip_relocation
    sha256 "10dc08755dac1164583b72c5ddae69d8a4c3e4c27c0d201283b64f3e5456d85a" => :catalina
    sha256 "8b481256d5a90b4254a51e0df45d5d0462780fe7c790fd32f80dcbcbb5dc3ff2" => :mojave
    sha256 "6bda6e3e5c099b3f2f38a8d584098e129e328c59344ffab585dea2dd4de241da" => :high_sierra
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
