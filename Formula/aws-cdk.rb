require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.43.1.tgz"
  sha256 "36750570a60fe0bed4960c5ebc85cb4367ed964801cb7d816995de956edbed10"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5438782c5ed1a2325d750e8ea4fa4ed2227925afe6c319dd9b98aed37c19d0eb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5438782c5ed1a2325d750e8ea4fa4ed2227925afe6c319dd9b98aed37c19d0eb"
    sha256 cellar: :any_skip_relocation, monterey:       "c437bd23aa92529588b005ecf4c6a475c0d2ec6575531858dadfbc1eb582e202"
    sha256 cellar: :any_skip_relocation, big_sur:        "c437bd23aa92529588b005ecf4c6a475c0d2ec6575531858dadfbc1eb582e202"
    sha256 cellar: :any_skip_relocation, catalina:       "c437bd23aa92529588b005ecf4c6a475c0d2ec6575531858dadfbc1eb582e202"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9bafd1a1e94404f8b2b6c293569694858cdead083870ce937bd2aed105ce11d9"
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
