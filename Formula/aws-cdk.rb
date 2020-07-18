require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.52.0.tgz"
  sha256 "cd8ce7540be1f00462bbb891c7966f862b71d340eaad648bd150f45e611899a4"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "0f04e5c82b633683d175127f36a6b9d8e3c4b259c2dbf90d61405eda62ddcebe" => :catalina
    sha256 "8966724f538061f1a07812118adb31899a7f10d3d78954c10ece5567ac3f48f5" => :mojave
    sha256 "029e811fe101552540404f8d0244784b5cbeff93dd9b23c33f3e09dad68520f5" => :high_sierra
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
