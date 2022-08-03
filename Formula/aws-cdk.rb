require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.35.0.tgz"
  sha256 "dba58c59cbb78bd625dce64ac1bca75d444e04b8b3600be711fdb1ae9796ce11"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a635ed409a8e1927bebf000d0c0aa2aa3c56fdc4ec99b04a61d03cd6df75341"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1a635ed409a8e1927bebf000d0c0aa2aa3c56fdc4ec99b04a61d03cd6df75341"
    sha256 cellar: :any_skip_relocation, monterey:       "5b1133b7a7f19cbd9612ed054cbb968cef1f83ec4cb5ad425038548f22b8e057"
    sha256 cellar: :any_skip_relocation, big_sur:        "5b1133b7a7f19cbd9612ed054cbb968cef1f83ec4cb5ad425038548f22b8e057"
    sha256 cellar: :any_skip_relocation, catalina:       "5b1133b7a7f19cbd9612ed054cbb968cef1f83ec4cb5ad425038548f22b8e057"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f75548dccd4e7ff2d886056e8e13f693c9635d6743679e08f9b0cc4a8cf2cd5"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Replace universal binaries with native slices.
    deuniversalize_machos
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
