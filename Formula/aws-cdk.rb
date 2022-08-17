require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.38.0.tgz"
  sha256 "eaaba718294b3fb52f95e127cd17d53b5aff7b1a9c432030a33e1a89af72394d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c10cfdb6fa16c7b147e65a547ea3b0d321fe32b33e1941f4278e09ce963ecfe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1c10cfdb6fa16c7b147e65a547ea3b0d321fe32b33e1941f4278e09ce963ecfe"
    sha256 cellar: :any_skip_relocation, monterey:       "a218866a2b137e5cf4ee6539b209d1794c8a88ad17e3ef0956a08ce9052ed8f7"
    sha256 cellar: :any_skip_relocation, big_sur:        "a218866a2b137e5cf4ee6539b209d1794c8a88ad17e3ef0956a08ce9052ed8f7"
    sha256 cellar: :any_skip_relocation, catalina:       "a218866a2b137e5cf4ee6539b209d1794c8a88ad17e3ef0956a08ce9052ed8f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e8ade5e0391aa306f80efbfdd5c7c900fecb172e258d179d121f8b23ef8f7ae"
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
