require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.27.0.tgz"
  sha256 "0b8213d2bdde788a802f4c59849fe48ef1f6427456cd3b1b7f7599c6bab6eea8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fdbccc6defe140954745d46a352554ffd6ec150d7e0d68aa2035de08decc8707"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fdbccc6defe140954745d46a352554ffd6ec150d7e0d68aa2035de08decc8707"
    sha256 cellar: :any_skip_relocation, monterey:       "79eda47e8c81c407d847e5742cfbbdcf35049661eb36461186092eaa57e399a5"
    sha256 cellar: :any_skip_relocation, big_sur:        "79eda47e8c81c407d847e5742cfbbdcf35049661eb36461186092eaa57e399a5"
    sha256 cellar: :any_skip_relocation, catalina:       "79eda47e8c81c407d847e5742cfbbdcf35049661eb36461186092eaa57e399a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7eff3bd901cbbaa246d3cf0babcd30cf310e482c6409fbd7c21c639ab407a61"
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
