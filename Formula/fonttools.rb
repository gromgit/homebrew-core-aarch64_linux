class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/4.10.0/fonttools-4.10.0.zip"
  sha256 "59c58444267685335ad5a347cf45dea119244be34a9e86adb63354b703549749"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7d322788cb205d4279ab0b061340b313cceda960f768c94d15f5466c69126964" => :catalina
    sha256 "66ff54d2939ee42b397bddc5a26648ba6a9ec27b5a8b4698351f72035fa5b0dd" => :mojave
    sha256 "101982dbfbebbb8eba59f6cfa554acddf6f61eff08a3b63d48fc267a9422d4b1" => :high_sierra
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
