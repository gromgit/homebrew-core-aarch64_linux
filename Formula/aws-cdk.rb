require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.21.1.tgz"
  sha256 "f5adc112697e23d32c2ce3f244508f895020b417dd5a5edeafd257260d301ac0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bbeea6b225d31e7d23aa3b1df1f2b93aeb245de72b75a060b7e73ed78014783c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bbeea6b225d31e7d23aa3b1df1f2b93aeb245de72b75a060b7e73ed78014783c"
    sha256 cellar: :any_skip_relocation, monterey:       "6d2236550c5377ac31472336882a25cd176e9c1d43cdf65fa89d46c6abc59e5b"
    sha256 cellar: :any_skip_relocation, big_sur:        "6d2236550c5377ac31472336882a25cd176e9c1d43cdf65fa89d46c6abc59e5b"
    sha256 cellar: :any_skip_relocation, catalina:       "6d2236550c5377ac31472336882a25cd176e9c1d43cdf65fa89d46c6abc59e5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b76a5d3ead8c8aaede87c76f705128d0fcc2bce69aea6c4a1e72e82411eab513"
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
