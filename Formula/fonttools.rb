class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/47/7c/dd9dc174842a9bc6fdae89045e820acd8a53a2251b4a8e6d22c97e1c7d75/fonttools-4.25.2.zip"
  sha256 "507f8e027967fe4ebfa913856b3acc6b77201e67d6a6978d3666863cbba884c3"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c3bf47619aeffa821430c617aad930604f8ba9393cdf3b37d7fa9cb664785356"
    sha256 cellar: :any_skip_relocation, big_sur:       "5395d770cb2e91c3c1fd28cefed3e987f6a145cac25890aef363cc8769db66ae"
    sha256 cellar: :any_skip_relocation, catalina:      "5395d770cb2e91c3c1fd28cefed3e987f6a145cac25890aef363cc8769db66ae"
    sha256 cellar: :any_skip_relocation, mojave:        "5395d770cb2e91c3c1fd28cefed3e987f6a145cac25890aef363cc8769db66ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b4497b37560c090f7d41897d673686768499411ffb0cacfb665f60fcc228966"
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
