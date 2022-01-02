class Richmd < Formula
  include Language::Python::Virtualenv

  desc "Format Markdown in the terminal with Rich"
  homepage "https://github.com/willmcgugan/rich"
  url "https://files.pythonhosted.org/packages/74/c3/e55ebdd66540503cee29cd3bb18a90bcfd5587a0cf3680173c368be56093/rich-10.16.2.tar.gz"
  sha256 "720974689960e06c2efdb54327f8bf0cdbdf4eae4ad73b6c94213cad405c371b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6975bdae226d8b96e5275cdd90ba45f730a0cfc539d106ccde9134f83388b7f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d4bfdfaf3926ba529958bfb93f1885b4200253b58b85ab11493b97bf8496a811"
    sha256 cellar: :any_skip_relocation, monterey:       "8bd1b7528d34bf68884fd327415fc96088247642984ccdba45b2276dfe6e651a"
    sha256 cellar: :any_skip_relocation, big_sur:        "6995017d3d5ddd963bb9374ebed03c7c470f1c9e43cd7703e2bb8c336f6c0492"
    sha256 cellar: :any_skip_relocation, catalina:       "d07d6e8d4792c9a6bb4c071270067478d8a42413b4b07d6dba55c411e70eff76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec29286568d78062d4e97feb057074492fbc8f3f20fdc4ab8f966c0bce9502eb"
  end

  depends_on "python@3.10"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "commonmark" do
    url "https://files.pythonhosted.org/packages/60/48/a60f593447e8f0894ebb7f6e6c1f25dafc5e89c5879fdc9360ae93ff83f0/commonmark-0.9.1.tar.gz"
    sha256 "452f9dc859be7f06631ddcb328b6919c67984aca654e5fefb3914d54691aed60"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/15/53/5345177cafa79a49e02c27102019a01ef1682ab170d2138deca47a4c8924/Pygments-2.11.1.tar.gz"
    sha256 "59b895e326f0fb0d733fd28c6839bd18ad0687ba20efc26d4277fd1d30b971f4"
  end

  def install
    virtualenv_install_with_resources

    (bin/"richmd").write <<~SH
      #!/bin/bash
      #{libexec/"bin/python"} -m rich.markdown $@
    SH
  end

  test do
    (testpath/"foo.md").write("- Hello, World")
    assert_equal "• Hello, World", shell_output("#{bin}/richmd foo.md").strip
  end
end
