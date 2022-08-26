require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.39.0.tgz"
  sha256 "ae990dc06719fa5593131a50e0e836520b9214bb2ab3deeb0758d806c66a859b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "632fbac6162283215505bbaa90865864f5b641375d903d4df6f2063793830395"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "632fbac6162283215505bbaa90865864f5b641375d903d4df6f2063793830395"
    sha256 cellar: :any_skip_relocation, monterey:       "6cd635ad798937606218379aea6185134f12930f70b4903189ec4a3262f13ff4"
    sha256 cellar: :any_skip_relocation, big_sur:        "6cd635ad798937606218379aea6185134f12930f70b4903189ec4a3262f13ff4"
    sha256 cellar: :any_skip_relocation, catalina:       "6cd635ad798937606218379aea6185134f12930f70b4903189ec4a3262f13ff4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c0587517088593769aed3ae4b72d7ce42d417450401bc6e43f2622be1cbff66"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Replace universal binaries with native slices.
    deuniversalize_machos
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
