require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.34.0.tgz"
  sha256 "581b894e2ef2dbcf7e633adf529b694371f7defb8d5748c6ada107f73c2c15fd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b7fd289f10743e3a7ba879f254863fab64aa282062a019c7099d8739c0f5da5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7b7fd289f10743e3a7ba879f254863fab64aa282062a019c7099d8739c0f5da5"
    sha256 cellar: :any_skip_relocation, monterey:       "37c1fa8c4376aa089114108be2a9d244bf2440f7fd7cd634610b73102986f8d4"
    sha256 cellar: :any_skip_relocation, big_sur:        "37c1fa8c4376aa089114108be2a9d244bf2440f7fd7cd634610b73102986f8d4"
    sha256 cellar: :any_skip_relocation, catalina:       "37c1fa8c4376aa089114108be2a9d244bf2440f7fd7cd634610b73102986f8d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16eaa214c241eba76c9abf5a69673533f04c379e765f61ee386d30658d192701"
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
