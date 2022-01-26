require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.9.0.tgz"
  sha256 "dd12e2e88e6ed4f5bd5ac5e9db172f7f5fad7dd36f9ccee89b3b628b4dbc8ec5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a8849ba1a5783ef3913c158cea644be211c25ab6d7c3fc2e52a117c7dabc0f9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5a8849ba1a5783ef3913c158cea644be211c25ab6d7c3fc2e52a117c7dabc0f9"
    sha256 cellar: :any_skip_relocation, monterey:       "aad37ed3812f7dc4793a44441a3cf76e34af3d81e6274c946f62a90e374c992d"
    sha256 cellar: :any_skip_relocation, big_sur:        "aad37ed3812f7dc4793a44441a3cf76e34af3d81e6274c946f62a90e374c992d"
    sha256 cellar: :any_skip_relocation, catalina:       "aad37ed3812f7dc4793a44441a3cf76e34af3d81e6274c946f62a90e374c992d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0beace98fbc371ea4b59a223c24c4512eae802b64ad274072bbf7d60f62e31f7"
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
