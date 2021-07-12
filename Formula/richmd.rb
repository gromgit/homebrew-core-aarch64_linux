class Richmd < Formula
  include Language::Python::Virtualenv

  desc "Format Markdown in the terminal with Rich"
  homepage "https://github.com/willmcgugan/rich"
  url "https://files.pythonhosted.org/packages/72/f5/1f06eb039318ae8eb4d13e4abe52dd0b1fdd466b35cf9e52a2e505509532/rich-10.6.0.tar.gz"
  sha256 "128261b3e2419a4ef9c97066ccc2abbfb49fa7c5e89c3fe4056d00aa5e9c1e65"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6c242d1f818fb4ade24c8864c9f262bcd5fa1cfd06105d21f6910b4b4aeefeef"
    sha256 cellar: :any_skip_relocation, big_sur:       "998f24b0479dcf8be800ad1085deee695572c44444e8d771b5c38439e8763dc7"
    sha256 cellar: :any_skip_relocation, catalina:      "237cd533f21581d2e97c139245c2acba6596a54a092e453de8852c0ba8b99e24"
    sha256 cellar: :any_skip_relocation, mojave:        "77fe4ea619e9d9403d4b19912d7858409804a5ba4281c8b64b0af65755245128"
  end

  depends_on "python@3.9"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "commonmark" do
    url "https://files.pythonhosted.org/packages/60/48/a60f593447e8f0894ebb7f6e6c1f25dafc5e89c5879fdc9360ae93ff83f0/commonmark-0.9.1.tar.gz"
    sha256 "452f9dc859be7f06631ddcb328b6919c67984aca654e5fefb3914d54691aed60"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/ba/6e/7a7c13c21d8a4a7f82ccbfe257a045890d4dbf18c023f985f565f97393e3/Pygments-2.9.0.tar.gz"
    sha256 "a18f47b506a429f6f4b9df81bb02beab9ca21d0a5fee38ed15aef65f0545519f"
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
