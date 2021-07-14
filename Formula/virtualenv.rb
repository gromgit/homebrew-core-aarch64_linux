class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/38/0a/1edcf3e106680167b4a2db90782c80c7910bcbfe79610921503d9cbe0d87/virtualenv-20.5.0.tar.gz"
  sha256 "6b0e3eeb6cb081c9c81ec85633785e29edcdf6ff271d70e0d1e2bd616495c08c"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1f691389e7674a57173b4fe228a53355300aeb63ebc56b5a5600f38324c5e4a6"
    sha256 cellar: :any_skip_relocation, big_sur:       "71b72ed55b7c24e18ae6a6cce2e3696421e86932d6e98f1570ed30dd10a84d53"
    sha256 cellar: :any_skip_relocation, catalina:      "d5bbab08495a5df01a4d20c38016c664d3c53e7008f7b0ff0f365726a5bc3364"
    sha256 cellar: :any_skip_relocation, mojave:        "cb5d78013036c2f4c3b68fa9b5022d66062ac71ee5ff90b01967809327b55f7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8dc7a6003424c9478c5a687f2532e6fd04d1d2d83efb7ed2844e66ea83122171"
  end

  depends_on "python@3.9"

  resource "backports.entry-points-selectable" do
    url "https://files.pythonhosted.org/packages/e4/7e/249120b1ba54c70cf988a8eb8069af1a31fd29d42e3e05b9236a34533533/backports.entry_points_selectable-1.1.0.tar.gz"
    sha256 "988468260ec1c196dab6ae1149260e2f5472c9110334e5d51adcb77867361f6a"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/45/97/15fdbef466e12c890553cebb1d8b1995375202e30e0c83a1e51061556143/distlib-0.3.2.zip"
    sha256 "106fef6dc37dd8c0e2c0a60d3fca3e77460a48907f335fa28420463a6f799736"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/14/ec/6ee2168387ce0154632f856d5cc5592328e9cf93127c5c9aeca92c8c16cb/filelock-3.0.12.tar.gz"
    sha256 "18d82244ee114f543149c66a6e0c14e9c4f8a1044b5cdaadd0f82159d6a6ff59"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/c1/03/1dcc356abdfbe22bec1194852b02ed809c8bdf91e416b26f17f485c62984/platformdirs-2.0.2.tar.gz"
    sha256 "3b00d081227d9037bbbca521a5787796b5ef5000faea1e43fd76f1d44b06fcfa"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/virtualenv", "venv_dir"
    assert_match "venv_dir", shell_output("venv_dir/bin/python -c 'import sys; print(sys.prefix)'")
  end
end
