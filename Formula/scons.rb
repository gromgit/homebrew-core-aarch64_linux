class Scons < Formula
  include Language::Python::Virtualenv

  desc "Substitute for classic 'make' tool with autoconf/automake functionality"
  homepage "https://www.scons.org/"
  url "https://files.pythonhosted.org/packages/c6/63/3a87df61a5d8e1b2ba116f4889f3dbc2717ebe2e34c77b2d34e4e6b9deef/SCons-4.4.0.tar.gz"
  sha256 "7703c4e9d2200b4854a31800c1dbd4587e1fa86e75f58795c740bcfa7eca7eaa"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/scons"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "190d0846f22a0ad3841a7ce2b13c5f3cf985026dccda6ecc40b23d530cd9b895"
  end

  depends_on "python@3.10"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      int main()
      {
        printf("Homebrew");
        return 0;
      }
    EOS
    (testpath/"SConstruct").write "Program('test.c')"
    system bin/"scons"
    assert_equal "Homebrew", shell_output("#{testpath}/test")
  end
end
