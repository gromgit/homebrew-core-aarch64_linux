class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/3c/ea/a39a173e7943a8f001e1f97326f88e1535b945a3aec31130c3029dce19df/virtualenv-20.16.3.tar.gz"
  sha256 "d86ea0bb50e06252d79e6c241507cb904fcd66090c3271381372d6221a3970f9"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "30242747075262fda65d59ae420b00f84bf1374d8fb11f878d76ca831d495a94"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1810e7f448c6189eb18ed11c932131ce1222ee53e22f90b79e76fcc1452bd6b2"
    sha256 cellar: :any_skip_relocation, monterey:       "f7d37e9c90589659f392d080b3c4419bc3679b01b93accc8be4ad89377ff2d4e"
    sha256 cellar: :any_skip_relocation, big_sur:        "86b0d88863e152af3a0204c12fb627fe543904db1bd97dcaab6dd9a3520c0add"
    sha256 cellar: :any_skip_relocation, catalina:       "f0e523591b4582d4621e030b8f6664c669e323fea7f2e8113ffdc138ba0cc17d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79cfa218530a9f89b9faf4371e0971f1112b4b19a4da36667ac1d9ac95ff04bf"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/31/d5/e2aa0aa3918c8d88c4c8e4ebbc50a840e101474b98cd83d3c1712ffe5bb4/distlib-0.3.5.tar.gz"
    sha256 "a7f75737c70be3b25e2bee06288cec4e4c221de18455b2dd037fe2a795cab2fe"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/f3/c7/5c1aef87f1197d2134a096c0264890969213c9cbfb8a4102087e8d758b5c/filelock-3.7.1.tar.gz"
    sha256 "3a0fd85166ad9dbab54c9aec96737b744106dc5f15c0b09a6744a445299fcf04"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/ff/7b/3613df51e6afbf2306fc2465671c03390229b55e3ef3ab9dd3f846a53be6/platformdirs-2.5.2.tar.gz"
    sha256 "58c8abb07dcb441e6ee4b11d8df0ac856038f944ab98b7be6b27b2a3c7feef19"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/virtualenv", "venv_dir"
    assert_match "venv_dir", shell_output("venv_dir/bin/python -c 'import sys; print(sys.prefix)'")
  end
end
