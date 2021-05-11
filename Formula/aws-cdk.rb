require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.103.0.tgz"
  sha256 "2827bb36ffe77198334acd453b2723fe1b71b7e5f0edcbbbd4012e439f75d153"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "73b27d2d3efa919fc613bdbbb803df39846c156e27f6afd7d4b8a8c4f268395b"
    sha256 cellar: :any_skip_relocation, big_sur:       "9cfb5d867c85f355338b1d1f2b4eeabc12544c6e06e3694e22dfcb9a13187900"
    sha256 cellar: :any_skip_relocation, catalina:      "9cfb5d867c85f355338b1d1f2b4eeabc12544c6e06e3694e22dfcb9a13187900"
    sha256 cellar: :any_skip_relocation, mojave:        "9cfb5d867c85f355338b1d1f2b4eeabc12544c6e06e3694e22dfcb9a13187900"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
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
