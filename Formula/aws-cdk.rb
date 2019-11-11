require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.16.0.tgz"
  sha256 "4094e6ff489436a79930798ed490f9f1747ddb6bcb8ba2f005f291060cea4462"

  bottle do
    cellar :any_skip_relocation
    sha256 "a0de425d7492092c6214013afdf028e9c5c9923ae895a8500f5af144f3d6086d" => :catalina
    sha256 "bf769fd6d92021ece355fe99c3efa782f41407aff24bbe141b8ff570307f2f04" => :mojave
    sha256 "dd107e530bd33a960c6dff45ded8ed4a112d472ddc2d27a6a9ed7c07f3da0605" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    mkdir "testapp"
    cd testpath/"testapp"
    shell_output("#{bin}/cdk init app --language=javascript")
    list = shell_output("#{bin}/cdk list")
    cdkversion = shell_output("#{bin}/cdk --version")
    assert_match "TestappStack", list
    assert_match version.to_s, cdkversion
  end
end
