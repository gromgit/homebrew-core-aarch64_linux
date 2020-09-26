require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.64.1.tgz"
  sha256 "db225154fa5c59ccb5696c9003dfb4e217601b31613b116b7ea0d9fef3b6263e"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "bc76400043a768f904a0678dcce9329a04de0d52995730e8ec92052efd1fdb5f" => :catalina
    sha256 "f54cb76537455eb038cbeace75aabb65777347291334f8a93268d0c664977b76" => :mojave
    sha256 "44e0abbac7d075c616ca717d3806f2e0f4989859336fdbb93be00cf2f6f44235" => :high_sierra
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
