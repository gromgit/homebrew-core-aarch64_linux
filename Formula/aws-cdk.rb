require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.64.0.tgz"
  sha256 "b14d8f10a9ba5b23dec4eae2d830cb47579a36283b52f22a1e54e25a235ce6ba"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "44a4f94d573f41aa5a019604eb855792a78393233d45045d01c526fd9428c636" => :catalina
    sha256 "226ae29dc2376667d398868237e4e74f1b4b01c129f8709630938fe9bcee34ee" => :mojave
    sha256 "3629c99e70a32ff038d7589df61ad9c8fb837ece296052b39e486350639b3184" => :high_sierra
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
