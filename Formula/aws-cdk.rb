require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.95.2.tgz"
  sha256 "9de38f616cdc8537de60b7d957038f165ac42c7c213e794ca8e705556482d4a7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "33221eabe84d18af5c1cbc27b5eaf3cfd60abe8cd25aed3da68a0d657a64e2ef"
    sha256 cellar: :any_skip_relocation, big_sur:       "1afdd53427fe1465367beb2b4847410fcb312f75c8b575a37292bb11e5dc4862"
    sha256 cellar: :any_skip_relocation, catalina:      "41e4a0a765bdf6ee5aea82dbd4702c0c5e95ce3db04a544f24d4598128bb9645"
    sha256 cellar: :any_skip_relocation, mojave:        "81276f04ac17be0435279739a258d4a525fd5d4d629a3ca635dfadce31c2431c"
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
