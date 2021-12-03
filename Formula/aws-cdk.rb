require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.0.0.tgz"
  sha256 "6a285256204e13e58a3ea266d00b255d8997e18439c8bb99b101fcdd8809ec6b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1182ea7610381b0d4c2fc3abadc15e4519facce4692000e5ce0c65dcca12bbe8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1182ea7610381b0d4c2fc3abadc15e4519facce4692000e5ce0c65dcca12bbe8"
    sha256 cellar: :any_skip_relocation, monterey:       "66277d527ad4d14afa52a39a60e7440ada86a0478534aa97bcb8c0c5c68fb703"
    sha256 cellar: :any_skip_relocation, big_sur:        "66277d527ad4d14afa52a39a60e7440ada86a0478534aa97bcb8c0c5c68fb703"
    sha256 cellar: :any_skip_relocation, catalina:       "66277d527ad4d14afa52a39a60e7440ada86a0478534aa97bcb8c0c5c68fb703"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d9c948e3665c5705d0f7397a3e607440f8a59d644013d500f9914a25ad08095"
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
