require "language/node"

class Cdktf < Formula
  desc "Cloud Development Kit for Terraform"
  homepage "https://github.com/hashicorp/terraform-cdk"
  url "https://registry.npmjs.org/cdktf-cli/-/cdktf-cli-0.8.0.tgz"
  sha256 "21943e63242e8e39a8159d76fe4f53eed3a441af20d299276c09a4b980809444"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a4f0ca83b8b3c246968845381aba17645095a77eaa75a61fc00b660e618d989"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8a4f0ca83b8b3c246968845381aba17645095a77eaa75a61fc00b660e618d989"
    sha256 cellar: :any_skip_relocation, monterey:       "278b08cf2ed3aa943a9d1ed56bea6989d6fae9c10c464dbc7b1efde8fb259e0c"
    sha256 cellar: :any_skip_relocation, big_sur:        "278b08cf2ed3aa943a9d1ed56bea6989d6fae9c10c464dbc7b1efde8fb259e0c"
    sha256 cellar: :any_skip_relocation, catalina:       "278b08cf2ed3aa943a9d1ed56bea6989d6fae9c10c464dbc7b1efde8fb259e0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a4f0ca83b8b3c246968845381aba17645095a77eaa75a61fc00b660e618d989"
  end

  depends_on "node"
  depends_on "terraform"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "ERROR: Cannot initialize a project in a non-empty directory",
      shell_output("#{bin}/cdktf init --template='python' 2>&1", 1)
  end
end
