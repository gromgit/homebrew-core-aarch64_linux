class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/63/a2/67135688584ada5508fd8a1d0331290801f6e8c7e46612ea030e6811cda3/fonttools-4.28.3.zip"
  sha256 "edb48922873d3fda489ab400bd40888ac239ae8070b53f494b839bcdff0d01f6"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ac3933aee99dbf02da458b33685e3b703e973f3d6b17426817807460eff4d65"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3ac3933aee99dbf02da458b33685e3b703e973f3d6b17426817807460eff4d65"
    sha256 cellar: :any_skip_relocation, monterey:       "aef4382050975767e3cacc1b77c5055bdfa1f3741b603359aff500c479f4b7b5"
    sha256 cellar: :any_skip_relocation, big_sur:        "aef4382050975767e3cacc1b77c5055bdfa1f3741b603359aff500c479f4b7b5"
    sha256 cellar: :any_skip_relocation, catalina:       "aef4382050975767e3cacc1b77c5055bdfa1f3741b603359aff500c479f4b7b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e4d3424d92f1cf996784a96344fc783eb17982d9320606c9164837fbd4d72e3"
  end

  depends_on "python@3.10"

  def install
    virtualenv_install_with_resources
  end

  test do
    on_macos do
      cp "/System/Library/Fonts/ZapfDingbats.ttf", testpath
      system bin/"ttx", "ZapfDingbats.ttf"
    end
    on_linux do
      assert_match "usage", shell_output("#{bin}/ttx -h")
    end
  end
end
