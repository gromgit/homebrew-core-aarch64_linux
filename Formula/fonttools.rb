class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/3c/d5/f722e0d1aed0d547383913c6bc3c4ff35772952057b8e2b8fe3be8df4216/fonttools-4.28.2.zip"
  sha256 "dca694331af74c8ad47acc5171e57f6b78fac5692bf050f2ab572964577ac0dd"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d55d39e6054028672dba62978fa5db7f240b2c1ac1b56fdcabb004b488ad6c71"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d55d39e6054028672dba62978fa5db7f240b2c1ac1b56fdcabb004b488ad6c71"
    sha256 cellar: :any_skip_relocation, monterey:       "a9d97473e62778207fe83d99c6b240138aa07704fd64275ecc8272712e58beb6"
    sha256 cellar: :any_skip_relocation, big_sur:        "a9d97473e62778207fe83d99c6b240138aa07704fd64275ecc8272712e58beb6"
    sha256 cellar: :any_skip_relocation, catalina:       "a9d97473e62778207fe83d99c6b240138aa07704fd64275ecc8272712e58beb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "878fc3e5c040348e072ecfd506d0737376f171a37d85c2e0b25c16fc04a3ad7e"
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
