class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/af/c1/e4371eba2a9291bac65d6c5729ba0cf8ebf29d294b5bbb84210205bd3f01/fonttools-4.24.0.zip"
  sha256 "a77b5c1cf6db4adbe0c67574cc314af2f3a439aeaf6e7607177c0eb78c36a200"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4916300ca397b1dcfe3065e0fa31402bcfd1dc2f67ff35602fa48653e5fde681"
    sha256 cellar: :any_skip_relocation, big_sur:       "65557ac30e29bd28b930ebb51e0ea48bcbbbd7f4d1b71f775f4f19f3abb633fb"
    sha256 cellar: :any_skip_relocation, catalina:      "65557ac30e29bd28b930ebb51e0ea48bcbbbd7f4d1b71f775f4f19f3abb633fb"
    sha256 cellar: :any_skip_relocation, mojave:        "65557ac30e29bd28b930ebb51e0ea48bcbbbd7f4d1b71f775f4f19f3abb633fb"
  end

  depends_on "python@3.9"

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
