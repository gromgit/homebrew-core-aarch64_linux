class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-powered, cross-platform, Unix-gazing shell language and command prompt"
  homepage "https://xon.sh/"
  url "https://files.pythonhosted.org/packages/89/e6/2424ef1ac42191ce5022706aea829c22aabfeae7b80a1b34b99a006d0889/xonsh-0.12.0.tar.gz"
  sha256 "0a6566d3b64c509e24691d19e237f9dfdaaa18d595a533a3c2439d31a5ece042"
  license "BSD-2-Clause-Views"
  head "https://github.com/xonsh/xonsh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c16080f094704eef8cc02759397ed9792bca4714e423d8654ae5391c345c686"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e6de15d83abd17a930df5857d0c5374e8776051044d471ec40a874319c64c4f7"
    sha256 cellar: :any_skip_relocation, monterey:       "c2f5d0a62ac663e3f4da8c6343c637d0a47c606b978d1c7a6045cde9a37cf950"
    sha256 cellar: :any_skip_relocation, big_sur:        "69f76298c8ffbce3959c82b43de8f543af9e5a18e13df5f03a5c9fa2e3c33a33"
    sha256 cellar: :any_skip_relocation, catalina:       "5eac46f0f78f944fb944957e55ff661341e7a2b1887f3a8aebeea55303b3df2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46c8f115814ec97203303fc23a9150a8860ab5d0dc67af5238987ca587dadeab"
  end

  depends_on "python@3.10"

  # Resources based on `pip3 install xonsh[ptk,pygments,proctitle]`
  # See https://xon.sh/osx.html#dependencies

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/59/68/4d80f22e889ea34f20483ae3d4ca3f8d15f15264bcfb75e52b90fb5aefa5/prompt_toolkit-3.0.29.tar.gz"
    sha256 "bd640f60e8cecd74f0dc249713d433ace2ddc62b65ee07f96d358e0b152b6ea7"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/94/9c/cb656d06950268155f46d4f6ce25d7ffc51a0da47eadf1b164bbf23b718b/Pygments-2.11.2.tar.gz"
    sha256 "4e426f72023d88d03b2fa258de560726ce890ff3b630f88c21cbb8b2503b8c6a"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/a7/2c/4c64579f847bd5d539803c8b909e54ba087a79d01bb3aba433a95879a6c5/pyperclip-1.8.2.tar.gz"
    sha256 "105254a8b04934f0bc84e9c24eb360a591aaf6535c9def5f29d92af107a9bf57"
  end

  resource "setproctitle" do
    url "https://files.pythonhosted.org/packages/a1/7f/a1d4f4c7b66f0fc02f35dc5c85f45a8b4e4a7988357a29e61c14e725ef86/setproctitle-1.2.2.tar.gz"
    sha256 "7dfb472c8852403d34007e01d6e3c68c57eb66433fb8a5c77b13b89a160d97df"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/89/38/459b727c381504f361832b9e5ace19966de1a235d73cdbdea91c771a1155/wcwidth-0.2.5.tar.gz"
    sha256 "c4d647b99872929fdb7bdcaa4fbe7f01413ed3d98077df798530e5b04f116c83"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "4", shell_output("#{bin}/xonsh -c 2+2")
  end
end
