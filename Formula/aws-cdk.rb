require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.47.0.tgz"
  sha256 "454c9fa3a0661d3d3be80a6f9ab3556bb54aee4628f8708f76eee506c74ad903"

  bottle do
    cellar :any_skip_relocation
    sha256 "0f0f9dc2950c3ddaf6e69734185e392923432896c08eaa22df1f3b1a6c6d061e" => :catalina
    sha256 "f33d0e0f9b2fc27175f135e750469d0e7abf5cb4870a516097baba247a2a7936" => :mojave
    sha256 "86e61b10b182334701359fbe618388eadbadfec4b3f4e7cf2f9b43ac456bf91c" => :high_sierra
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
