class Pywhat < Formula
  include Language::Python::Virtualenv

  desc "🐸 Identify anything: emails, IP addresses, and more 🧙"
  homepage "https://github.com/bee-san/pyWhat"
  url "https://files.pythonhosted.org/packages/59/e7/f8ecea5b09bf3e1ef74b0d61ed5ad2fb17e00188f31947a7bc9f9f9d7853/pywhat-2.0.0.tar.gz"
  sha256 "bf0fb5637441566c23868a1ed349209d673dfa477cc11bb5f5bc7390d04c9ed1"
  license "GPL-3.0-or-later"
  head "https://github.com/bee-san/pyWhat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ee8a987b1a61b027316a2ce589c496854b51a4f54868bab8345107540f81482d"
    sha256 cellar: :any_skip_relocation, big_sur:       "2691d20218705d419999182d48fa84deaa8b53e320a888be7664c8279d5f7557"
    sha256 cellar: :any_skip_relocation, catalina:      "6150a7c5c2348fdb554c9a75fb5ec9039feeee65d0d30d49e42e83d4c6c7d6b1"
    sha256 cellar: :any_skip_relocation, mojave:        "84b30728f490a6c94e35af6ba129b1ce3df77cea3280d36180a267ac69a100fe"
  end

  depends_on "python@3.9"
  depends_on "six"

  resource "click" do
    url "https://files.pythonhosted.org/packages/27/6f/be940c8b1f1d69daceeb0032fee6c34d7bd70e3e649ccac0951500b4720e/click-7.1.2.tar.gz"
    sha256 "d2b5255c7c6349bc1bd1e59e08cd12acbbd63ce649f2588755783aa94dfb6b1a"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "commonmark" do
    url "https://files.pythonhosted.org/packages/60/48/a60f593447e8f0894ebb7f6e6c1f25dafc5e89c5879fdc9360ae93ff83f0/commonmark-0.9.1.tar.gz"
    sha256 "452f9dc859be7f06631ddcb328b6919c67984aca654e5fefb3914d54691aed60"
  end

  resource "langdetect" do
    url "https://files.pythonhosted.org/packages/0e/72/a3add0e4eec4eb9e2569554f7c70f4a3c27712f40e3284d483e88094cc0e/langdetect-1.0.9.tar.gz"
    sha256 "cbc1fef89f8d062739774bd51eda3da3274006b3661d199c2655f6b3f6d605a0"
  end

  resource "name-that-hash" do
    url "https://files.pythonhosted.org/packages/83/b4/bd1ad28c46023baa8af4a813ee31298c4d3d81937886e900f56af04d634a/name-that-hash-1.9.0.tar.gz"
    sha256 "77f848196b339ec2ae8dc7f2ec1197401eb7cb9605f880c7813b342251e5cf89"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/ba/6e/7a7c13c21d8a4a7f82ccbfe257a045890d4dbf18c023f985f565f97393e3/Pygments-2.9.0.tar.gz"
    sha256 "a18f47b506a429f6f4b9df81bb02beab9ca21d0a5fee38ed15aef65f0545519f"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/42/6e/549283c6f8b9fff54ee8bd35558eb51d3796b1f71509d3385011d9a8c857/rich-10.3.0.tar.gz"
    sha256 "a83bff83309687e1859c75b499879738b135d700738dd2721c22965497af05bd"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Internet Protocol (IP)", shell_output("#{bin}/pywhat 127.0.0.1").strip
  end
end
