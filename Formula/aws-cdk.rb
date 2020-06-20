require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.46.0.tgz"
  sha256 "eb0af583a7056847ebbf26ff7e449da030023e52309f3fb63b9b517298d59e7d"

  bottle do
    cellar :any_skip_relocation
    sha256 "4b7fe22c27e630d128cab8101129cff2eb0e6d0df549e541337740cd70737a3a" => :catalina
    sha256 "623c88fbf1372820eab85ec874d20eb066de4bfeb34f76ab1e86fcf7a7ff5b96" => :mojave
    sha256 "6096cc5ce8f112986189ba5ba7d73f83379bda40d038077436d88d0162aa1bc8" => :high_sierra
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
