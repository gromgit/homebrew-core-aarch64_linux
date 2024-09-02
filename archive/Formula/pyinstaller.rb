class Pyinstaller < Formula
  include Language::Python::Virtualenv

  desc "Bundle a Python application and all its dependencies"
  homepage "https://pyinstaller.org/"
  url "https://files.pythonhosted.org/packages/ad/09/82d3f066eddb9ab3cbed8284a0bda84a93806ff2c44536474841a98ae0e7/pyinstaller-5.0.1.tar.gz"
  sha256 "25f5f758b005c66471af0d452c90ec328179116afe9d5bd82f5fb06d9416267b"
  license "GPL-2.0-or-later"
  head "https://github.com/pyinstaller/pyinstaller.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d6e03804e1676310f50aaac061ba4fbbde1cb5e9bce72747e5da4f25ba28188"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2960c2033f41a3649b09e0c88f186fb461b69e077e478be47bcff82f980fe171"
    sha256 cellar: :any_skip_relocation, monterey:       "f5de29bf658db9778d204f7688d09490d8b1406248ca9027295bcf116aebbd5d"
    sha256 cellar: :any_skip_relocation, big_sur:        "6060cc43e7668a561a22c8be59de483cb5590bbb1a34f2bf8ae6cb83076b007a"
    sha256 cellar: :any_skip_relocation, catalina:       "470ddb2a7762e66557c381da5bc1a550077c8e84008661c72ab3f573084b878b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afc9926a550721ac536df12b3880e9e92f2aa23651a34f536b1a0dcff1d6bc6c"
  end

  depends_on "python@3.10"

  resource "altgraph" do
    url "https://files.pythonhosted.org/packages/a9/f1/62830c4915178dbc6948687916603f1cd37c2c299634e4a8ee0efc9977e7/altgraph-0.17.2.tar.gz"
    sha256 "ebf2269361b47d97b3b88e696439f6e4cbc607c17c51feb1754f90fb79839158"
  end

  resource "macholib" do
    url "https://files.pythonhosted.org/packages/16/1b/85fd523a1d5507e9a5b63e25365e0a26410d5b6ee89082426e6ffff30792/macholib-1.16.tar.gz"
    sha256 "001bf281279b986a66d7821790d734e61150d52f40c080899df8fefae056e9f7"
  end

  resource "pyinstaller-hooks-contrib" do
    url "https://files.pythonhosted.org/packages/4c/c9/065f97b7e89dcb438ce3e270f3f28af5cba759f4127afe14ce6038701270/pyinstaller-hooks-contrib-2022.4.tar.gz"
    sha256 "b7f7da20e5b83c22219a21b8f849525e5f735197975313208f4e07ff9549cdaf"
  end

  def install
    cd "bootloader" do
      system "python3", "./waf", "all", "--no-universal2", "STRIP=/usr/bin/strip"
    end
    virtualenv_install_with_resources
  end

  test do
    (testpath/"easy_install.py").write <<~EOS
      """Run the EasyInstall command"""

      if __name__ == '__main__':
          from setuptools.command.easy_install import main
          main()
    EOS
    system bin/"pyinstaller", "-F", "--distpath=#{testpath}/dist", "--workpath=#{testpath}/build",
                              "#{testpath}/easy_install.py"
    assert_predicate testpath/"dist/easy_install", :exist?
  end
end
