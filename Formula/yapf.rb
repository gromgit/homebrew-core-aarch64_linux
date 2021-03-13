class Yapf < Formula
  include Language::Python::Virtualenv

  desc "Formatter for python code"
  homepage "https://github.com/google/yapf"
  url "https://files.pythonhosted.org/packages/85/60/8532f7ca17cea13de00e80e2fe1e6bd59a9379856706a027536b19daf0d3/yapf-0.31.0.tar.gz"
  sha256 "408fb9a2b254c302f49db83c59f9aa0b4b0fd0ec25be3a5c51181327922ff63d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1e2e3659b521d218c9720c5c81b0a7a8c48b27844acfb391aaf2abc24809e84c"
    sha256 cellar: :any_skip_relocation, big_sur:       "c35f2e09c0d2ec13eb3372b99d149e821695f9657a4b0a77f4f9936837e9a8d3"
    sha256 cellar: :any_skip_relocation, catalina:      "c7595c7ea199301a266e69b60acda9a7497d2d4de333f4dce36ca17a487acb43"
    sha256 cellar: :any_skip_relocation, mojave:        "8de973e622e29c2d6c9d1ba1d8c15adb8645b09fd14f22ca01ad156533124109"
    sha256 cellar: :any_skip_relocation, high_sierra:   "5d489433ca30742c5569ba46ff7ae6a23f3971035d7f5bf35bb3486979cf4414"
  end

  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("echo \"x='homebrew'\" | #{bin}/yapf")
    assert_equal "x = 'homebrew'", output.strip
  end
end
