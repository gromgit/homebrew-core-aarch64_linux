class Pylint < Formula
  include Language::Python::Virtualenv

  desc "It's not just a linter that annoys you!"
  homepage "https://github.com/PyCQA/pylint"
  url "https://files.pythonhosted.org/packages/29/c5/6fa87d306b7bf82369fdd8676be017c23b3cd05a4d28e2bbe238e31d762b/pylint-2.8.1.tar.gz"
  sha256 "ad1bff19c46bfc6d2aeba4de5f76570d253df4915d2043ba61dc6a96233c4bd6"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "50030badfd68e1b665f034153e86e6fb2630657e7b2047000f057cea206732af"
    sha256 cellar: :any_skip_relocation, big_sur:       "455b039582844704fecfafdba95bb83097f90a5598a1cd1abe4efb2be92429af"
    sha256 cellar: :any_skip_relocation, catalina:      "f8b7493bcf402db374578c8dec554353a1efaee48eee3d8d8d519b38c6fce8fb"
    sha256 cellar: :any_skip_relocation, mojave:        "75f81592290ba33136ef1af665a3b6797b9dc8e892926220a7c660c1948ed217"
  end

  depends_on "python@3.9"

  resource "astroid" do
    url "https://files.pythonhosted.org/packages/bc/72/51d6389690b30adf1ad69993923f81b71b2110b16e02fd0afd378e30c43c/astroid-2.5.6.tar.gz"
    sha256 "8a398dfce302c13f14bab13e2b14fe385d32b73f4e4853b9bdfb64598baa1975"
  end

  resource "isort" do
    url "https://files.pythonhosted.org/packages/31/8a/6f5449a7be67e4655069490f05fa3e190f5f5864e6ddee140f60fe5526dd/isort-5.8.0.tar.gz"
    sha256 "0a943902919f65c5684ac4e0154b1ad4fac6dcaa5d9f3426b732f1c8b5419be6"
  end

  resource "lazy-object-proxy" do
    url "https://files.pythonhosted.org/packages/bb/f5/646893a04dcf10d4acddb61c632fd53abb3e942e791317dcdd57f5800108/lazy-object-proxy-1.6.0.tar.gz"
    sha256 "489000d368377571c6f982fba6497f2aa13c6d1facc40660963da62f5c379726"
  end

  resource "mccabe" do
    url "https://files.pythonhosted.org/packages/06/18/fa675aa501e11d6d6ca0ae73a101b2f3571a565e0f7d38e062eec18a91ee/mccabe-0.6.1.tar.gz"
    sha256 "dd8d182285a0fe56bace7f45b5e7d1a6ebcbf524e8f3bd87eb0f125271b8831f"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/82/f7/e43cefbe88c5fd371f4cf0cf5eb3feccd07515af9fd6cf7dbf1d1793a797/wrapt-1.12.1.tar.gz"
    sha256 "b62ffa81fb85f4332a4f609cab4ac40709470da05643a082ec1eb88e6d9b97d7"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"pylint_test.py").write <<~EOS
      print('Test file'
      )
    EOS
    system bin/"pylint", "--exit-zero", "pylint_test.py"
  end
end
