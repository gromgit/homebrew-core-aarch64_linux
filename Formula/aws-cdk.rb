require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.43.0.tgz"
  sha256 "b3e1fa074de91e6bacf269073d6551e49a9237bc09a6112c07b814d6499b1465"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "689eb32deba796586725df9c69696d2a10b3e6a9c3b61857f5fcb41e97e3caf2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "689eb32deba796586725df9c69696d2a10b3e6a9c3b61857f5fcb41e97e3caf2"
    sha256 cellar: :any_skip_relocation, monterey:       "ddab46ea8863c39a2524f89dd7a35b414df5b93c4ceccae81624e46439bfa193"
    sha256 cellar: :any_skip_relocation, big_sur:        "ddab46ea8863c39a2524f89dd7a35b414df5b93c4ceccae81624e46439bfa193"
    sha256 cellar: :any_skip_relocation, catalina:       "ddab46ea8863c39a2524f89dd7a35b414df5b93c4ceccae81624e46439bfa193"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c27a0cf6a817b4bf79635bd82568ed2a7b0998b418e557eb13b5d020d475cd6a"
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
