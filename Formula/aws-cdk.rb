require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.36.0.tgz"
  sha256 "79a8a4906e99c7d375358c228ad7904a8a84814a5b6a7056acbbac09bbc1f1c2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fded37f201cf414d73ded0d6cfaed187757c48d2a7725fb15e288e9c9e0d30d0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fded37f201cf414d73ded0d6cfaed187757c48d2a7725fb15e288e9c9e0d30d0"
    sha256 cellar: :any_skip_relocation, monterey:       "968bdc25f7adbf6474946344d7652d1e5e2f63a0c6bcb799822509ed0ddd331f"
    sha256 cellar: :any_skip_relocation, big_sur:        "968bdc25f7adbf6474946344d7652d1e5e2f63a0c6bcb799822509ed0ddd331f"
    sha256 cellar: :any_skip_relocation, catalina:       "968bdc25f7adbf6474946344d7652d1e5e2f63a0c6bcb799822509ed0ddd331f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70463742a7c4948d634e559d238a60651c92457a1b4ba55ede71ab1a16fdacc6"
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
