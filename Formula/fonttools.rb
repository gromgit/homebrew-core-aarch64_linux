class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/ec/af/760f22b73789c2b22deb37f6b21fee37fe5051740ede0b4e3f25fe8bcb28/fonttools-4.18.0.zip"
  sha256 "4e5b8bdf31f7c00248b42599eef761e57f2cf82884f83e992af972b84bac968b"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cfadebeeb4a7e53f0fa57a4ad37defcf0045895ddadbdebe09edee29a1fa1e68" => :big_sur
    sha256 "e2c0cfb1924c02f6ca32533491a0b882b41a469c4c065baa4b51c57ff5700e63" => :catalina
    sha256 "3d3dfadb7f64c90f0d3763ba51ed2c694aa7240efe6462ff562efeeb473e2ce3" => :mojave
  end

  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
  end

  test do
    cp "/System/Library/Fonts/ZapfDingbats.ttf", testpath
    system bin/"ttx", "ZapfDingbats.ttf"
  end
end
