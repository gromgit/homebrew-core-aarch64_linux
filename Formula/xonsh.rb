class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-ish, BASHwards-compatible shell language and command prompt"
  homepage "https://xon.sh/"
  url "https://github.com/xonsh/xonsh/archive/0.9.21.tar.gz"
  sha256 "b6f6a0fc8b388480bbf7aa1900dc97edf63d100a7dd572be8e5031b754e1c9f5"
  license "BSD-2-Clause-Views"
  revision 1
  head "https://github.com/xonsh/xonsh.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "00e93c376da82ba8980bd7b48aa04d11bbc15ff69b4e5474cb249df6f227dea3" => :catalina
    sha256 "b3b57321c204d4046a7e5dd78aad41a370d1d70d11aab4a4f28a3cb6e634008a" => :mojave
    sha256 "31b662c6d1a620cfd9035b0d8321b2fec1abee9439b780fb2af1bfcf2a171ade" => :high_sierra
  end

  depends_on "python@3.9"

  # Resources based on `pip3 install xonsh[ptk,pygments,proctitle]`
  # See https://xon.sh/osx.html#dependencies

  resource "prompt_toolkit" do
    url "https://files.pythonhosted.org/packages/c4/c6/03da4efaf73f0cb5a34957fdac12046eb8d8e81618bad6f60464215b829a/prompt_toolkit-3.0.6.tar.gz"
    sha256 "7630ab85a23302839a0f26b31cc24f518e6155dea1ed395ea61b42c45941b6a6"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/6e/4d/4d2fe93a35dfba417311a4ff627489a947b01dc0cc377a3673c00cf7e4b2/Pygments-2.6.1.tar.gz"
    sha256 "647344a061c249a3b74e230c739f434d7ea4d8b1d5f3721bc0f3558049b38f44"
  end

  resource "setproctitle" do
    url "https://files.pythonhosted.org/packages/5a/0d/dc0d2234aacba6cf1a729964383e3452c52096dc695581248b548786f2b3/setproctitle-1.1.10.tar.gz"
    sha256 "6283b7a58477dd8478fbb9e76defb37968ee4ba47b05ec1c053cb39638bd7398"
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
