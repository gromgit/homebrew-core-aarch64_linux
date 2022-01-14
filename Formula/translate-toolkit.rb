class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/43/62/413b9a7d76f651fc61c4a0f24554f3023a63b243340ddf12427ecc3a9621/translate-toolkit-3.5.3.tar.gz"
  sha256 "b7ca3e0e8f69c306c372e05a0a814ecafa6176d30ce314e787378dabf3e48dfb"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "53ed98e315bfcaf5e22e6d0e4764ebb0684bee3418fa3ac40724d0a85ff35924"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "271c7d9e4164f785177c7745d4604f7cdbe7624d7e57d09729fdcb87c80ba079"
    sha256 cellar: :any_skip_relocation, monterey:       "0d27584d4f308f514437913276cd66554de4caa4080a378bba574c890dc9624e"
    sha256 cellar: :any_skip_relocation, big_sur:        "9198ea874fb246a454d0750289d8a44ccb4d8667cf95671e235ba8c98effe4b6"
    sha256 cellar: :any_skip_relocation, catalina:       "e71bb387af6d6684deba4ec45dd6e346a7b7524debf53c821e26ad9ee0fd4f6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0900cfda447fcff6de7ac14426b0618cf535ccde71031ead8488350153ca3d65"
  end

  depends_on "python@3.10"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/84/74/4a97db45381316cd6e7d4b1eb707d7f60d38cb2985b5dfd7251a340404da/lxml-4.7.1.tar.gz"
    sha256 "a1613838aa6b89af4ba10a0f3a972836128801ed008078f8c1244e65958f1b24"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"pretranslate", "-h"
    system bin/"podebug", "-h"
  end
end
