require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.134.0.tgz"
  sha256 "dec7ffde4e9a3e49e71d25bb5e07a6ca5fc8fcdc71e45b3008a6965e296a2a06"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be226397f1ef3fa4510e475d7a67a6fee355938b575128650409d7b3caad9387"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "be226397f1ef3fa4510e475d7a67a6fee355938b575128650409d7b3caad9387"
    sha256 cellar: :any_skip_relocation, monterey:       "caaf9544492cb693f84bb22a405cf33fcb6abd7fb8d8cc695b51a72c92766e3e"
    sha256 cellar: :any_skip_relocation, big_sur:        "caaf9544492cb693f84bb22a405cf33fcb6abd7fb8d8cc695b51a72c92766e3e"
    sha256 cellar: :any_skip_relocation, catalina:       "caaf9544492cb693f84bb22a405cf33fcb6abd7fb8d8cc695b51a72c92766e3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b992047247b3d68481453c7a00b915a1b87afc367d7886745f963f963b94c68"
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
