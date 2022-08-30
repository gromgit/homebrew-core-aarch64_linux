require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.39.1.tgz"
  sha256 "ec8b5746af9a03917ac74548f41c226981f98f929585aec71063fb8e88dc602e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e5201b4b9f93596f49f27da25bbd941917ac8fb04b73560f5f271724c4426ad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1e5201b4b9f93596f49f27da25bbd941917ac8fb04b73560f5f271724c4426ad"
    sha256 cellar: :any_skip_relocation, monterey:       "f0b8f7424f084e49a72be22283125eb764f49253595767e845c80c6849c26a5a"
    sha256 cellar: :any_skip_relocation, big_sur:        "f0b8f7424f084e49a72be22283125eb764f49253595767e845c80c6849c26a5a"
    sha256 cellar: :any_skip_relocation, catalina:       "f0b8f7424f084e49a72be22283125eb764f49253595767e845c80c6849c26a5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0193573df3628567d5f4d1da0e061eb7b6f14e25cb35076998eaa4e26880e53"
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
