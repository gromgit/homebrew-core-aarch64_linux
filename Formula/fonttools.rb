class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/4.12.0/fonttools-4.12.0.zip"
  sha256 "c9589820710345b8bdaacd1cffdccc28f1a00272ae99d1dad294eae01dc4cb10"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "023deec6d26319155cbe45c02e06ca3c538cc5d3404ec5d8cfcd8a9ffe9f05df" => :catalina
    sha256 "c996df7783085a7367fb9994e9cf6a765508e6193ba088745749adac63517302" => :mojave
    sha256 "1cb5d1cc0a57b893c61ffa29a46e7654924bc4e98cb621d4e4f7d495186067fc" => :high_sierra
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
