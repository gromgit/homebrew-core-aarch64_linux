require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.37.0.tgz"
  sha256 "8667a7b012f2b83bc7fc96358d984480d4b7966032d9cd182bf8758de24f214b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8cb96703aed39a429ab8c7af242d0b17195431acfeb7ad87fdbfca62dcaa2032"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8cb96703aed39a429ab8c7af242d0b17195431acfeb7ad87fdbfca62dcaa2032"
    sha256 cellar: :any_skip_relocation, monterey:       "80c70f7eb3045a0acd610deb271ec72d53aa717ec2fc9e244a0381fca5f28bc0"
    sha256 cellar: :any_skip_relocation, big_sur:        "80c70f7eb3045a0acd610deb271ec72d53aa717ec2fc9e244a0381fca5f28bc0"
    sha256 cellar: :any_skip_relocation, catalina:       "80c70f7eb3045a0acd610deb271ec72d53aa717ec2fc9e244a0381fca5f28bc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ab26dced6e9eefdd8b3b166c8a7d56076a19e179c8da89aecb68a97f73f6438"
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
