require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.36.1.tgz"
  sha256 "ac94bf120c4a09c37fd1851a0a58a2bb0d21bdc5e90ddc8bf4d904185f0bb31f"

  bottle do
    cellar :any_skip_relocation
    sha256 "fde834ed33131ac6aa042a4e7be703a79dff651c78b219df07b2257a1431f2a1" => :catalina
    sha256 "11517c552ce8e6ca5b5eb1fe5c1ca0681ff9bbd418e2eee530646e16e6bad28a" => :mojave
    sha256 "7b8af53bac2ee975b6e86e984c40c15b6769728a7104f9ba295c93c9bfff1177" => :high_sierra
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
