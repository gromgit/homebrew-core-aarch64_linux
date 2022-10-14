require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.46.0.tgz"
  sha256 "25b9c8860c61a9e46e3d5359cfd88f437fd45c3f9934a2f19e53de1bc28075c2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ecc15b9b85c5f93f9b69f2779f490b167e992bc393d334cb4ed32f348ec32e9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4ecc15b9b85c5f93f9b69f2779f490b167e992bc393d334cb4ed32f348ec32e9"
    sha256 cellar: :any_skip_relocation, monterey:       "3f55aa6305a3714894dc2cfeb1871d7c1ae11ae84dd76a50bf8ef26e87854ae1"
    sha256 cellar: :any_skip_relocation, big_sur:        "3f55aa6305a3714894dc2cfeb1871d7c1ae11ae84dd76a50bf8ef26e87854ae1"
    sha256 cellar: :any_skip_relocation, catalina:       "3f55aa6305a3714894dc2cfeb1871d7c1ae11ae84dd76a50bf8ef26e87854ae1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "223e1a6dfcbaa0d0263b683f04a5a27b5e78ac64987094f8ee5bcbc1e581ce2b"
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
