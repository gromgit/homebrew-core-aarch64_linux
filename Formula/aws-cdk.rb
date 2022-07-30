require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.34.2.tgz"
  sha256 "904eb71d03ca13db0f3ae32ab74c55674d2be6e8499205fc0d4de98f7f09e76b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1cdfbd603ec443cf75730c5fe2636d40fc540df37dc350cb577d65616bd808fb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1cdfbd603ec443cf75730c5fe2636d40fc540df37dc350cb577d65616bd808fb"
    sha256 cellar: :any_skip_relocation, monterey:       "0d7e5510fcc1b171ca3f2970b96decf89fe379bda712f256c55dd8203b525c87"
    sha256 cellar: :any_skip_relocation, big_sur:        "0d7e5510fcc1b171ca3f2970b96decf89fe379bda712f256c55dd8203b525c87"
    sha256 cellar: :any_skip_relocation, catalina:       "0d7e5510fcc1b171ca3f2970b96decf89fe379bda712f256c55dd8203b525c87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "542c87762a7eeb182c6998321bed4e9129c8b86eeb97e078fa90cf045a619378"
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
