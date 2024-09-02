class Jc < Formula
  include Language::Python::Virtualenv

  desc "Serializes the output of command-line tools to structured JSON output"
  homepage "https://github.com/kellyjonbrazil/jc"
  url "https://files.pythonhosted.org/packages/aa/4a/7799d45dd74222d8614861eb122b0aa6f41ef4f5777897264fa74aa6cbfc/jc-1.18.8.tar.gz"
  sha256 "e3e7ca4223c504e9e434f222157364582eeeb76d6313c8515a67b7637911448a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a95f525989ad778c89d96268df54241b057b05725fa918c7137812373685596"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "829b7f372db2caf73d16f223f953f3324cb4a81e198bfddf210797c32ff5773c"
    sha256 cellar: :any_skip_relocation, monterey:       "604995ae8a24f56d6c3dcf42da6e3c72a794dce1c47e035c8e06f35057ce8c73"
    sha256 cellar: :any_skip_relocation, big_sur:        "f24394a8a13bccac0f4f9d94fbaf370cc46beb4ff0e995db156f4e5f172cde52"
    sha256 cellar: :any_skip_relocation, catalina:       "7e5d9b7b8988a158db32c8071bb5950192a270bd5d06fb6a199dc4cbe01a2e76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7564aed3061c94136500bb6ffe583807f3771edf856775cfa2acf6ec8ba1a995"
  end

  depends_on "python@3.10"

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/59/0f/eb10576eb73b5857bc22610cdfc59e424ced4004fe7132c8f2af2cc168d3/Pygments-2.12.0.tar.gz"
    sha256 "5eb116118f9612ff1ee89ac96437bb6b49e8f04d8a13b514ba26f620208e26eb"
  end

  resource "ruamel.yaml" do
    url "https://files.pythonhosted.org/packages/46/a9/6ed24832095b692a8cecc323230ce2ec3480015fbfa4b79941bd41b23a3c/ruamel.yaml-0.17.21.tar.gz"
    sha256 "8b7ce697a2f212752a35c1ac414471dc16c424c9573be4926b56ff3f5d23b7af"
  end

  resource "ruamel.yaml.clib" do
    url "https://files.pythonhosted.org/packages/8b/25/08e5ad2431a028d0723ca5540b3af6a32f58f25e83c6dda4d0fcef7288a3/ruamel.yaml.clib-0.2.6.tar.gz"
    sha256 "4ff604ce439abb20794f05613c374759ce10e3595d1867764dd1ae675b85acbd"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/58/40/0d783e14112e064127063fbf5d1fe1351723e5dfe9d6daad346a305f6c49/xmltodict-0.12.0.tar.gz"
    sha256 "50d8c638ed7ecb88d90561beedbf720c9b4e851a9fa6c47ebd64e99d166d8a21"
  end

  def install
    virtualenv_install_with_resources
    man1.install "man/jc.1"
  end

  test do
    assert_equal "[{\"header1\":\"data1\",\"header2\":\"data2\"}]\n", \
                  pipe_output("#{bin}/jc --csv", "header1, header2\n data1, data2")
  end
end
