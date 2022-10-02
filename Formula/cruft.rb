class Cruft < Formula
  include Language::Python::Virtualenv

  desc "Utility that creates projects from templates and maintains the cruft afterwards"
  homepage "https://cruft.github.io/cruft/"
  url "https://files.pythonhosted.org/packages/07/ea/bbddd490ec84648ad5bde447cebe57628ec8d427cfb5cf4e6ce7cb0d9d89/cruft-2.11.1.tar.gz"
  sha256 "deae3ee097f091462d7c872df22d6ad0ac89ce870bd1665e716e0d08fd21357b"
  license "MIT"
  revision 1
  head "https://github.com/cruft/cruft.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "04b124c2f7eb6c8f82f2178030cd6466a4feeeb8e2fa0009093363f63ad036bc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6fefe4a7d231dc304bf2f1588adface9723b71339ccaab6d28be8231c16c0399"
    sha256 cellar: :any_skip_relocation, monterey:       "0203ef80d321c786e91c0728952018fa26636a6259abc09851d5456b110d76b2"
    sha256 cellar: :any_skip_relocation, big_sur:        "27b0782bb49b8014afdc1a4cbcb2d2fdfb5033fb1df65e6af5d23a65cd454f5a"
    sha256 cellar: :any_skip_relocation, catalina:       "340fb4026c0c05c7029ac3bc2aa37687fc1c4a3ddaa03f07e2812f95b25464c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d86fbf2aa5601951c2d876197d8066f18e9938fa79580e2c78b68b7aca3f5e8"
  end

  depends_on "cookiecutter"
  depends_on "python@3.10"
  depends_on "six"

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/fc/44/64e02ef96f20b347385f0e9c03098659cb5a1285d36c3d17c56e534d80cf/gitdb-4.0.9.tar.gz"
    sha256 "bac2fd45c0a1c9cf619e63a90d62bdc63892ef92387424b855792a6cabe789aa"
  end

  resource "GitPython" do
    url "https://files.pythonhosted.org/packages/d6/39/5b91b6c40570dc1c753359de7492404ba8fe7d71af40b618a780c7ad1fc7/GitPython-3.1.27.tar.gz"
    sha256 "1c885ce809e8ba2d88a29befeb385fcea06338d3640712b59ca623c220bb5704"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/21/2d/39c6c57032f786f1965022563eec60623bb3e1409ade6ad834ff703724f3/smmap-5.0.0.tar.gz"
    sha256 "c840e62059cd3be204b0c9c9f74be2c09d5648eddd4580d9314c3ecde0b30936"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/cf/f9/27c5cd9ab067e3ece4cecb920c33f38cc986f839b12de19650fd49dc3c63/typer-0.6.1.tar.gz"
    sha256 "2d5720a5e63f73eaf31edaa15f6ab87f35f0690f8ca233017d7d23d743a91d73"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/b2/56/d87d6d3c4121c0bcec116919350ca05dc3afd2eeb7dc88d07e8083f8ea94/urllib3-1.26.12.tar.gz"
    sha256 "3fa96cf423e6987997fc326ae8df396db2a8b7c667747d47ddd8ecba91f4a74e"
  end

  def install
    virtualenv_install_with_resources

    # we depend on cookiecutter, but that's a separate formula, so install a `.pth` file to link them
    site_packages = Language::Python.site_packages("python3.10")
    cookiecutter = Formula["cookiecutter"].opt_libexec
    (libexec/site_packages/"homebrew-cookiecutter.pth").write cookiecutter/site_packages
  end

  test do
    system bin/"cruft", "create", "--no-input", "https://github.com/audreyr/cookiecutter-pypackage.git"
    assert (testpath/"python_boilerplate").directory?
    assert_predicate testpath/"python_boilerplate/.cruft.json", :exist?
  end
end
