require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.121.0.tgz"
  sha256 "59da982690f1093f685e21e9ac4f06f8d922fcab49086a5b2c043e8f530491d8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "cb11cb59b8bff264c471e7a20e049a090015b663df2a82eb94085ea9184dcad4"
    sha256 cellar: :any_skip_relocation, big_sur:       "50328c2f71e7524eb77779a30f0c640dd994c92e919ebb05df5daee116d55fa8"
    sha256 cellar: :any_skip_relocation, catalina:      "50328c2f71e7524eb77779a30f0c640dd994c92e919ebb05df5daee116d55fa8"
    sha256 cellar: :any_skip_relocation, mojave:        "50328c2f71e7524eb77779a30f0c640dd994c92e919ebb05df5daee116d55fa8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb11cb59b8bff264c471e7a20e049a090015b663df2a82eb94085ea9184dcad4"
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
