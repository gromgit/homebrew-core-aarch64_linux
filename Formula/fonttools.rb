class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/d1/c1/536594312f90b4ae9b592e71f795cdb9f4167f06036baada15ffbb78e7d1/fonttools-4.22.0.zip"
  sha256 "5777efffcd7559163af4497464ee451392a940681682a452b54897bc02e070d7"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "25c8519b23db28176bc64e04e689b3357851c57a391638762a6d5b734df364e3"
    sha256 cellar: :any_skip_relocation, big_sur:       "81279f204344f80a429c3ded21e71134a7a3cd4052b6d6d8fcaac1886acb3ba2"
    sha256 cellar: :any_skip_relocation, catalina:      "7cfc50aa8cafeb3ff4529196c4fbbe8eae641be25599fa30c545fc1192029abc"
    sha256 cellar: :any_skip_relocation, mojave:        "dc57fb513859a2734d2d07d6842e76aead61d54fc92ce5849e9b2668b5b3698c"
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
