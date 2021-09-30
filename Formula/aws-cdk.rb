require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.125.0.tgz"
  sha256 "7c598ca2c6d292f384bac49d9514cad2caf8474a86e96a17458d56fde719450f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "27a5986216b6d0efe998cd7c69c5bed99b7570fc7a92f8f427ff9466c3e6c01e"
    sha256 cellar: :any_skip_relocation, big_sur:       "a8033b12852f5dffe8029a6f630f58d5d62ce82accc86cc0d2555e653948c4c0"
    sha256 cellar: :any_skip_relocation, catalina:      "a8033b12852f5dffe8029a6f630f58d5d62ce82accc86cc0d2555e653948c4c0"
    sha256 cellar: :any_skip_relocation, mojave:        "a8033b12852f5dffe8029a6f630f58d5d62ce82accc86cc0d2555e653948c4c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27a5986216b6d0efe998cd7c69c5bed99b7570fc7a92f8f427ff9466c3e6c01e"
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
