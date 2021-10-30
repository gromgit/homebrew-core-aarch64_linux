class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/cc/b7/247e773c926ea735e0a5f9b70d389c1c589eff9e63b9f13b446487777a59/translate-toolkit-3.5.0.tar.gz"
  sha256 "6feba6d7e2f4dd2bcffa21c5b9cdb917e5a835afdec526f63d526a2f260fa2fc"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "39c4cadc2ff8063fc42d48d808653519d41a14e78f69b5d8b4320e4a2b18eb66"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c2ee426411c346ecf85cbb0b50f88ee64fa213323dbb5ca22fc4adbda314f25d"
    sha256 cellar: :any_skip_relocation, monterey:       "4c3177c722c59f4495d86991b162b16ab44c7e7635bdf434ce4c3e195e4f703a"
    sha256 cellar: :any_skip_relocation, big_sur:        "12bde4703bb24bd413ee15ae8adcf6fad32c023c1a67dc3b44bd9210c9ba54f5"
    sha256 cellar: :any_skip_relocation, catalina:       "b7b7e795126299d060cee9145b3bdea8839c691f59b895ef5a4e0307137e2bfb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e64da4fb32b17bf883b18652392d37183cae93fa4a151d058bdf77ee36bdd70"
  end

  depends_on "python@3.10"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/e5/21/a2e4517e3d216f0051687eea3d3317557bde68736f038a3b105ac3809247/lxml-4.6.3.tar.gz"
    sha256 "39b78571b3b30645ac77b95f7c69d1bffc4cf8c3b157c435a34da72e78c82468"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"pretranslate", "-h"
    system bin/"podebug", "-h"
  end
end
