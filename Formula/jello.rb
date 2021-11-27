class Jello < Formula
  include Language::Python::Virtualenv

  desc "Filter JSON and JSON Lines data with Python syntax"
  homepage "https://github.com/kellyjonbrazil/jello"
  url "https://files.pythonhosted.org/packages/6a/14/be42019984b3d701e0201b76a148103a75ddb659985a5046654f9e1a313f/jello-1.4.5.tar.gz"
  sha256 "200057e2c43184c2b3c2a707a5810f134ff9e1cfb18201eb9f2fa03fc0484501"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3cd029691c21f37d47f3d1ba6b75a1f78aed5f7bbfd490a6c72f0abfb58b1a77"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3cd029691c21f37d47f3d1ba6b75a1f78aed5f7bbfd490a6c72f0abfb58b1a77"
    sha256 cellar: :any_skip_relocation, monterey:       "69cdf7acdf53cd1e4160f8a6249fb7d24798fee9958778dbe88567aebdb06ec3"
    sha256 cellar: :any_skip_relocation, big_sur:        "69cdf7acdf53cd1e4160f8a6249fb7d24798fee9958778dbe88567aebdb06ec3"
    sha256 cellar: :any_skip_relocation, catalina:       "69cdf7acdf53cd1e4160f8a6249fb7d24798fee9958778dbe88567aebdb06ec3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "146a49f980a83b3e72c1790f5bfc791cf458b81ba8b2ce138d8d2e5177c6af09"
  end

  depends_on "python@3.10"

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/b7/b3/5cba26637fe43500d4568d0ee7b7362de1fb29c0e158d50b4b69e9a40422/Pygments-2.10.0.tar.gz"
    sha256 "f398865f7eb6874156579fdf36bc840a03cab64d1cde9e93d68f46a425ec52c6"
  end

  def install
    virtualenv_install_with_resources
    man1.install "jello/man/jello.1"
  end

  test do
    assert_equal "1\n", pipe_output("#{bin}/jello _.foo", "{\"foo\":1}")
  end
end
