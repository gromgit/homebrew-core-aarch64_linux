class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/c0/95/9dc382935deeede8a8ad93d90ec1d1c5019181ad634e3b917b77d3430082/fonttools-4.34.3.zip"
  sha256 "cb6eee1330423ffaa56af962aeb2b8db409dc8f98b9d8e79ea109a09d4168191"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "571833fb1cd67b065a3b4876a9822360447c5e582c81a4119e8b9b77737b7f58"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "571833fb1cd67b065a3b4876a9822360447c5e582c81a4119e8b9b77737b7f58"
    sha256 cellar: :any_skip_relocation, monterey:       "2ed1968c9d73ce47028cec08cfa6f439f4bd5330009e3676be66b1e3fb921624"
    sha256 cellar: :any_skip_relocation, big_sur:        "2ed1968c9d73ce47028cec08cfa6f439f4bd5330009e3676be66b1e3fb921624"
    sha256 cellar: :any_skip_relocation, catalina:       "2ed1968c9d73ce47028cec08cfa6f439f4bd5330009e3676be66b1e3fb921624"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2b95e5100057acf9f881cdfaa560e0e110c059a0793ce0b7af0bc82cddb3f85"
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
