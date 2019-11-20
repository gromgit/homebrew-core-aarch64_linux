require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.17.0.tgz"
  sha256 "8ec3c1ec9b785d519f84011db8a20711df723ba8292f7e0fe892371b2b39f25c"

  bottle do
    cellar :any_skip_relocation
    sha256 "30d20f94a4bfe1f62ad155dcaa55721417259039401b87258e3ac1df927c29f5" => :catalina
    sha256 "c21b06ceddc5ef085194e8abe4a527eac217369923e8c653a9b66a9a944307e1" => :mojave
    sha256 "4de3da96966539e7fb137e52eeeb11cf2f57d9ebf49c3834b30381dd770eb8e5" => :high_sierra
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
