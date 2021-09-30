require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.125.0.tgz"
  sha256 "7c598ca2c6d292f384bac49d9514cad2caf8474a86e96a17458d56fde719450f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fc0f07b7b69581c3a7c3bde15632eefba8e3669e40c9f50851d04ef3d716cf47"
    sha256 cellar: :any_skip_relocation, big_sur:       "75580da56bc8a1db63bea9c2a69a4ba7710b3decc8b84dda1605524a14108c25"
    sha256 cellar: :any_skip_relocation, catalina:      "75580da56bc8a1db63bea9c2a69a4ba7710b3decc8b84dda1605524a14108c25"
    sha256 cellar: :any_skip_relocation, mojave:        "75580da56bc8a1db63bea9c2a69a4ba7710b3decc8b84dda1605524a14108c25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc0f07b7b69581c3a7c3bde15632eefba8e3669e40c9f50851d04ef3d716cf47"
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
