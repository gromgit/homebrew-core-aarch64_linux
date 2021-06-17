require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.109.0.tgz"
  sha256 "d7ee053aff22ffcf284f634cd87acefaadd4e0d06a3d746fcd470715c24301c3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f6819498e4800801fcb92680b2c844ab654b3b28f3ec8d500107946276c6920c"
    sha256 cellar: :any_skip_relocation, big_sur:       "78d9eebe41df547b0f29867316d94dbe6bd327f6419db1341c0f3e6f09c2b57a"
    sha256 cellar: :any_skip_relocation, catalina:      "78d9eebe41df547b0f29867316d94dbe6bd327f6419db1341c0f3e6f09c2b57a"
    sha256 cellar: :any_skip_relocation, mojave:        "78d9eebe41df547b0f29867316d94dbe6bd327f6419db1341c0f3e6f09c2b57a"
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
