class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/15/10/c087a7e87346332e40ef24f2a18e3b288b0c0e8196c02e06f94ba4d964b7/fonttools-4.26.2.zip"
  sha256 "c1c0e03dd823e9e905232e875ea02dbb2dcd2ba195418c6d11bfaea49b9c774d"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "720ce3b06614ada6acbd7f53751b8d5409d85696960e5660aedc66de5fb63d90"
    sha256 cellar: :any_skip_relocation, big_sur:       "b8c387e3216ae6cf3756690b52acf240f4ac4d088f0300f3392aded6c2e733e7"
    sha256 cellar: :any_skip_relocation, catalina:      "b8c387e3216ae6cf3756690b52acf240f4ac4d088f0300f3392aded6c2e733e7"
    sha256 cellar: :any_skip_relocation, mojave:        "b8c387e3216ae6cf3756690b52acf240f4ac4d088f0300f3392aded6c2e733e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b12e4a0b93c421d67451e27f12a5e77126710d751570f1fe3ce9965e3a9ffe1b"
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
