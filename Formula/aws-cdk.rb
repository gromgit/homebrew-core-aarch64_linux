require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.38.1.tgz"
  sha256 "5cf3484a83867755f2b6a8034c921100a45725746295dd0f943b7f82e7cddfb6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "267b1ff371b06881b4da3d2c1eb896969f765c49d4ca92cb1026d3b7a5d5cb0d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "267b1ff371b06881b4da3d2c1eb896969f765c49d4ca92cb1026d3b7a5d5cb0d"
    sha256 cellar: :any_skip_relocation, monterey:       "b939d59cae3732c1f0a3bde2d4a622c11066ad6feecf3798627394a1a156dbc9"
    sha256 cellar: :any_skip_relocation, big_sur:        "b939d59cae3732c1f0a3bde2d4a622c11066ad6feecf3798627394a1a156dbc9"
    sha256 cellar: :any_skip_relocation, catalina:       "b939d59cae3732c1f0a3bde2d4a622c11066ad6feecf3798627394a1a156dbc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25abc2b441fa1c70ea5843769d1b9b915609d566357a770651b88e6842b9c8c5"
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
