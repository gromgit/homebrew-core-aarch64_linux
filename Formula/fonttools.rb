class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/e1/dd/e78a32ad831673e33dfc2565f7ffa90cc514688c267f400104bfbb8b0be7/fonttools-4.23.0.zip"
  sha256 "55f5a6474683ca96c50b71ff103d9766a9bcd8a0e90cd7272bd8e9c5aaaffdd7"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6552130275ee054e78aa046d2e9887eb5f08d05e7a80c5f6161bf267852558a2"
    sha256 cellar: :any_skip_relocation, big_sur:       "b2d9214026090858431c4330f7a73682cdc7d51af0aa6ecc0887b0fe70b700aa"
    sha256 cellar: :any_skip_relocation, catalina:      "b2d9214026090858431c4330f7a73682cdc7d51af0aa6ecc0887b0fe70b700aa"
    sha256 cellar: :any_skip_relocation, mojave:        "b2d9214026090858431c4330f7a73682cdc7d51af0aa6ecc0887b0fe70b700aa"
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
