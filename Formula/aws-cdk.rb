require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.133.0.tgz"
  sha256 "84be1eae28f56d6f4825bc0283a79969084734071930e2c4ec07f3fe210733a6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f2c14a37169728294b5f8c18c8690fd6843bb11642e8de062723cfe689f113f5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f2c14a37169728294b5f8c18c8690fd6843bb11642e8de062723cfe689f113f5"
    sha256 cellar: :any_skip_relocation, monterey:       "e8b23ba6e6ddff7cf9b4a47a772d2c84ffbabfd3bab665b36095a426ff58d489"
    sha256 cellar: :any_skip_relocation, big_sur:        "e8b23ba6e6ddff7cf9b4a47a772d2c84ffbabfd3bab665b36095a426ff58d489"
    sha256 cellar: :any_skip_relocation, catalina:       "e8b23ba6e6ddff7cf9b4a47a772d2c84ffbabfd3bab665b36095a426ff58d489"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5e346295ff04af205ac918513fe7ca6090084f183906f8849374c6dd715ee79"
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
