require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.31.1.tgz"
  sha256 "ad456a4c8a4a05b8ba9ceb1d53e5470f7873f4cc52980b49f2b6f83e0bd8edf4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1444278baaad75f844363b4d1fa649ad49e60573f4a797ae1fe4a349d73e0745"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1444278baaad75f844363b4d1fa649ad49e60573f4a797ae1fe4a349d73e0745"
    sha256 cellar: :any_skip_relocation, monterey:       "6ef93e0da3395a57e2abfb059019d9386863e0c1a5f78d37abbb470083778fab"
    sha256 cellar: :any_skip_relocation, big_sur:        "6ef93e0da3395a57e2abfb059019d9386863e0c1a5f78d37abbb470083778fab"
    sha256 cellar: :any_skip_relocation, catalina:       "6ef93e0da3395a57e2abfb059019d9386863e0c1a5f78d37abbb470083778fab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43d22d3b0e34a4a5cdc64fe643586b9e149da0e31652d1a13d2d4b0875087cd8"
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
