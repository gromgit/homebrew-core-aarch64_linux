require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.31.2.tgz"
  sha256 "e13954f93565d804d1e1c3085f5161848d8d8923f17a5704fdb81474351c1126"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68988844ba61e655b1258119c651c09c2515090033267f2048bb3767de019314"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "68988844ba61e655b1258119c651c09c2515090033267f2048bb3767de019314"
    sha256 cellar: :any_skip_relocation, monterey:       "c0038b4304d77d29ba256bc3ed37a6a45c5fc3a9822b156623782ad74a26d43a"
    sha256 cellar: :any_skip_relocation, big_sur:        "c0038b4304d77d29ba256bc3ed37a6a45c5fc3a9822b156623782ad74a26d43a"
    sha256 cellar: :any_skip_relocation, catalina:       "c0038b4304d77d29ba256bc3ed37a6a45c5fc3a9822b156623782ad74a26d43a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9b092ee6cc9afd93c1dfbe668175d20728e2d48e34c50107be6efb06125f9f3"
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
