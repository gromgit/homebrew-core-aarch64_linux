class Atdtool < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface for After the Deadline language checker"
  homepage "https://github.com/lpenz/atdtool"
  url "https://files.pythonhosted.org/packages/83/d1/55150f2dd9afda92e2f0dcb697d6f555f8b1f578f1df4d685371e8b81089/atdtool-1.3.3.tar.gz"
  sha256 "a83f50e7705c65e7ba5bc339f1a0624151bba9f7cdec7fb1460bb23e9a02dab9"
  license "BSD-3-Clause"
  revision 5

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/atdtool"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "47de69605d5dbe37ac0493f2f2c7e93805ee4eed0ad278447f80a664bbbb730d"
  end


  deprecate! date: "2020-11-18", because: :repo_archived

  depends_on "python@3.10"

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/atdtool", "--help"
  end
end
