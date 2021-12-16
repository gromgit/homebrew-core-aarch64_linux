require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.2.0.tgz"
  sha256 "ff64798e932afc613a55563be788a57eca7fb6749bfa738b706c6ae2cd7d675a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c7bc385724781db2a2a3e07283afff799599cf2a7421ea7e8504adf0e267dbe7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c7bc385724781db2a2a3e07283afff799599cf2a7421ea7e8504adf0e267dbe7"
    sha256 cellar: :any_skip_relocation, monterey:       "94bf1fa15914c50413bb9a169d6a4f5c6dbe366cee08a5d9c663aa0c1472f389"
    sha256 cellar: :any_skip_relocation, big_sur:        "94bf1fa15914c50413bb9a169d6a4f5c6dbe366cee08a5d9c663aa0c1472f389"
    sha256 cellar: :any_skip_relocation, catalina:       "94bf1fa15914c50413bb9a169d6a4f5c6dbe366cee08a5d9c663aa0c1472f389"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6bf36a748ff4cdcfb67ff33eaf1f51ef71ae726ca14266e45478eea6b9345462"
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
