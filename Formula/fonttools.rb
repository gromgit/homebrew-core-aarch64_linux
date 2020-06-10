class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/4.12.0/fonttools-4.12.0.zip"
  sha256 "c9589820710345b8bdaacd1cffdccc28f1a00272ae99d1dad294eae01dc4cb10"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b34726bb5a17cdf31c345105ea80a0ac8525312c2f31bc3622fca42b1b8d66c1" => :catalina
    sha256 "d8dbeba805163017c07211896a0312bde0e77211203be33e4ce941b70c0d1ce8" => :mojave
    sha256 "ddb0f0c422048b527666eedba16284dc46d9c83857ff7c2a4b876c8bd47d5fc0" => :high_sierra
  end

  depends_on "python@3.8"

  def install
    virtualenv_install_with_resources
  end

  test do
    cp "/System/Library/Fonts/ZapfDingbats.ttf", testpath
    system bin/"ttx", "ZapfDingbats.ttf"
  end
end
