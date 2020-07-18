require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.52.0.tgz"
  sha256 "cd8ce7540be1f00462bbb891c7966f862b71d340eaad648bd150f45e611899a4"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "2228c8c8ec23b06c11c093f7e15609082e91cda9b738900cd752913c91788fe9" => :catalina
    sha256 "e8822a85b7c893a6c102c5b32c8f5f13a8277c8917623ea207ed30fe14c21c84" => :mojave
    sha256 "f1751887c9ec71c19e73ad2a0027bab84df32fc9b71906c50554dfa8cf8b84ee" => :high_sierra
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
