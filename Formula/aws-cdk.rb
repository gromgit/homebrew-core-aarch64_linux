require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.30.0.tgz"
  sha256 "d599497cbb35cbc928fda2f5eb650c3d92b4f23e002ca2ea5b741338db755ea6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a13ff6d59b7cac23770a3bf5ef40b758491ce3d627e14e3461deea103935f85f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a13ff6d59b7cac23770a3bf5ef40b758491ce3d627e14e3461deea103935f85f"
    sha256 cellar: :any_skip_relocation, monterey:       "823e53d3af5aba2fae9285a51b2f5f4f3f8300e3173e3a1bb4f13beb91a52731"
    sha256 cellar: :any_skip_relocation, big_sur:        "823e53d3af5aba2fae9285a51b2f5f4f3f8300e3173e3a1bb4f13beb91a52731"
    sha256 cellar: :any_skip_relocation, catalina:       "823e53d3af5aba2fae9285a51b2f5f4f3f8300e3173e3a1bb4f13beb91a52731"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88b7f6c0af884831b2363375c66a954a6abc6c4d1cbf8dec685508d8af45c734"
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
