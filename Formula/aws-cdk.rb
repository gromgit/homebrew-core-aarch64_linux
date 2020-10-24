require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.70.0.tgz"
  sha256 "cd242dc0aa43ecf28b9f4dcabf9d7a1a4b4a10570df8d847effa10a0623ab208"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "53294a64bbdc9efdf8e324c2b02c5bc7c0ee16b1150b81be390e8e65e53871e3" => :catalina
    sha256 "a7b57375afb1d2971c50fdae4fe844062b2ebc4f4000815a7816f91ace7332a2" => :mojave
    sha256 "e1bfeed59493db5bf1516b04b3b0ee6f3d48a20c99b581cfe4800ac8a99b93a5" => :high_sierra
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
