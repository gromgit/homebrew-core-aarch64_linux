class Jc < Formula
  include Language::Python::Virtualenv

  desc "Serializes the output of command-line tools to structured JSON output"
  homepage "https://github.com/kellyjonbrazil/jc"
  url "https://files.pythonhosted.org/packages/42/e5/27fa5e75e663f303580bf9c64990b99afd3f3ae8bf342c94ff1153544502/jc-1.16.0.tar.gz"
  sha256 "8582c921abf5390d58cea2b751a5f277764a3c3be4f8d59ca887174c4d413ce2"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b9f8276a4e94f464dcd71e687e02635f8b93679fbd7897bad0f83debf6e33aa1"
    sha256 cellar: :any_skip_relocation, big_sur:       "1097379cd2764a042d73781e1a419acd33863c08b4e9d4f045d4ae91bbf80774"
    sha256 cellar: :any_skip_relocation, catalina:      "4903ad32d09dff2c009bba304783167bb92873014c23d3a3ede92109d7e6d660"
    sha256 cellar: :any_skip_relocation, mojave:        "881b22acd422ef4b6d6fb4ba912d03beb88924b15865fa0717f5f3f04829cb5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14acf5a1e6695470a073a055c4931540215a974b98cadef00fde6858cd549447"
  end

  depends_on "python@3.9"

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/ba/6e/7a7c13c21d8a4a7f82ccbfe257a045890d4dbf18c023f985f565f97393e3/Pygments-2.9.0.tar.gz"
    sha256 "a18f47b506a429f6f4b9df81bb02beab9ca21d0a5fee38ed15aef65f0545519f"
  end

  resource "ruamel.yaml" do
    url "https://files.pythonhosted.org/packages/83/59/4f576abb336d30b3d47061717224be714a9dc39c774061c34cb41c1795cf/ruamel.yaml-0.17.10.tar.gz"
    sha256 "106bc8d6dc6a0ff7c9196a47570432036f41d556b779c6b4e618085f57e39e67"
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
