require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.45.0.tgz"
  sha256 "6d836f21b3bd9e18bfdf2891eb0e8fbf968219114595e69644f025d773c093f5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "02a1fd27dbf4ce476ac228801340a88a13e4cfdbced56dee558a45c0841f51d6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "02a1fd27dbf4ce476ac228801340a88a13e4cfdbced56dee558a45c0841f51d6"
    sha256 cellar: :any_skip_relocation, monterey:       "28ba528ac222bfa82e96647ae55d24b2d5864dfbb994e0f0164cb9a9fa74c396"
    sha256 cellar: :any_skip_relocation, big_sur:        "28ba528ac222bfa82e96647ae55d24b2d5864dfbb994e0f0164cb9a9fa74c396"
    sha256 cellar: :any_skip_relocation, catalina:       "28ba528ac222bfa82e96647ae55d24b2d5864dfbb994e0f0164cb9a9fa74c396"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "831052b3f1799184e7fedffe65e76a97fe2ac9c2c55d1d6b863e2d286425b079"
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
