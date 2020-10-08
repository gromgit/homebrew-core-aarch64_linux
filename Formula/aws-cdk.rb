require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.67.0.tgz"
  sha256 "0a1254af0de2de5ce7cdaaf78a35a30421ca8427c0320acd39e90254f9f5dbb7"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "8d1db199ac90f4b35ee3dc5caff908f5367dc3c13047b2b1dac89cda7bcc8c86" => :catalina
    sha256 "c6b101bdf6a0247edf77bb2c0f427e81c664e1972cada0e3badffe56d2983f85" => :mojave
    sha256 "29e759b3f38e3e35cff0bf5aeaa539513de6073c205dbe38878c5553c7b3b0ea" => :high_sierra
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
