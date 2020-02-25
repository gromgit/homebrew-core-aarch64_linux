require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.25.0.tgz"
  sha256 "331f8e75f4e6e220911330c8ac71b8683e602170d70e8c73f36c2ec8173affab"

  bottle do
    cellar :any_skip_relocation
    sha256 "757ca29c7781c398eaeb6f43312af6608d729710b33bab47ef67946762867899" => :catalina
    sha256 "aba027f10b04444e91dde7871463541bce8516e17829c9beb77fb76013b7c6f6" => :mojave
    sha256 "f73c5df02e6fefab444f8b7c550065c35ab7bea51cea14b699926bda4288ae02" => :high_sierra
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
