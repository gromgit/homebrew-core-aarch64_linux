require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.32.0.tgz"
  sha256 "0ffbbfe467e10c14863c33d855cae1170f00234211fd798ef72e5083a20744a8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "44e80383159b7df9d1d7823d7aed6a8e6d0ee671768797a9ec287a8f9983e310"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "44e80383159b7df9d1d7823d7aed6a8e6d0ee671768797a9ec287a8f9983e310"
    sha256 cellar: :any_skip_relocation, monterey:       "18cd3fb054b53aff521e966b8500c4a6e20f3ab1e9ebc83a0d9bd92e91e26118"
    sha256 cellar: :any_skip_relocation, big_sur:        "18cd3fb054b53aff521e966b8500c4a6e20f3ab1e9ebc83a0d9bd92e91e26118"
    sha256 cellar: :any_skip_relocation, catalina:       "18cd3fb054b53aff521e966b8500c4a6e20f3ab1e9ebc83a0d9bd92e91e26118"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f8c8be11e8892a8c97280570ce87aa710bae2800d896c178ed7438f277d3f29"
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
