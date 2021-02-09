require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.89.0.tgz"
  sha256 "c40b09240f21cf9e70f92221661101efeaa4db4a411e421a1f177ad973084000"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6c13d82ebe6f18a3239067887cb55813dcd1bfa842b150ec5926b1e1db2a9ffb"
    sha256 cellar: :any_skip_relocation, big_sur:       "c7f9c360f7617c85afd4db83c41d1d20cf78ac4158adbcdf51a4ac67fa890359"
    sha256 cellar: :any_skip_relocation, catalina:      "a43b5886cc388b79b703bb802935f34d2a602f674a41ba13f6043d68ae9ee928"
    sha256 cellar: :any_skip_relocation, mojave:        "4557edd170aaac6e86d4de32d439fcfb4bfeb7ba4f017848281bb6b551c884ae"
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
