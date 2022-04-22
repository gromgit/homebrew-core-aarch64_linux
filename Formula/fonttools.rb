class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/f2/7f/415cc06c4278bbcda5c37b3e905fb1a2b9e63d93412c8531c12ca0628817/fonttools-4.33.1.zip"
  sha256 "66dd757b8a9d7b07d61c22b8d973282990c45343572b88e5fc722b3a8272598e"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3af2fe7a9994385efb51755b5215a2f2f4b746ad8cc1b4973149dab1e8e6893d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3af2fe7a9994385efb51755b5215a2f2f4b746ad8cc1b4973149dab1e8e6893d"
    sha256 cellar: :any_skip_relocation, monterey:       "05a1b82d04e1031a896b32c869d49568f0d0d803110451accdd6b2fa8b5e18a2"
    sha256 cellar: :any_skip_relocation, big_sur:        "05a1b82d04e1031a896b32c869d49568f0d0d803110451accdd6b2fa8b5e18a2"
    sha256 cellar: :any_skip_relocation, catalina:       "05a1b82d04e1031a896b32c869d49568f0d0d803110451accdd6b2fa8b5e18a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc2f05e3d27ba1dc1f8c1623ab6bc85567e0a972542093eb839ba6f7f74d5aef"
  end

  depends_on "python@3.10"

  def install
    virtualenv_install_with_resources
  end

  test do
    if OS.mac?
      cp "/System/Library/Fonts/ZapfDingbats.ttf", testpath
      system bin/"ttx", "ZapfDingbats.ttf"
    else
      assert_match "usage", shell_output("#{bin}/ttx -h")
    end
  end
end
