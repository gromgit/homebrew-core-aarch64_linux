class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/4.16.1/fonttools-4.16.1.zip"
  sha256 "991eb05e0366af5a6e620551f950a4f49433c5a8de70770a7066bcbe78bb86cc"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a423711703b8b5dade50911dbcee15032a31d719acf115958d66c072863b80e0" => :catalina
    sha256 "f64a488b1c4d9f91e56f06314287f5640bc11f6d0a525e74f094bffe7cdc48c6" => :mojave
    sha256 "cd26b383adffe507b7c401b42de001c5b053586d473523f685ca5e3ace7bc992" => :high_sierra
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
