class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/9a/93/e3f03ca37e97246612109ec04f3ea06f0d7b70267866b0d96d06782e1f4e/fonttools-4.25.1.zip"
  sha256 "86ac279648828beec635731c338b40cadca9681a7653653a84fc85fd6be60083"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d539538e6dea9a98b51515b086bc051b635a7dc8f6df53c41f8fb7ed7dadfbaa"
    sha256 cellar: :any_skip_relocation, big_sur:       "802dcb7de8ab5a65bcfc646b52aca60b3d2f49b6888db72fc451dc59ae0714b2"
    sha256 cellar: :any_skip_relocation, catalina:      "802dcb7de8ab5a65bcfc646b52aca60b3d2f49b6888db72fc451dc59ae0714b2"
    sha256 cellar: :any_skip_relocation, mojave:        "802dcb7de8ab5a65bcfc646b52aca60b3d2f49b6888db72fc451dc59ae0714b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d86f148c34c5c1ff56a4b16f98ecbcd7f444233228d1c917e89c9fbac09261a"
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
