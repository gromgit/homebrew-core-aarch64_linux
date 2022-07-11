class ReorderPythonImports < Formula
  include Language::Python::Virtualenv

  desc "Rewrites source to reorder python imports"
  homepage "https://github.com/asottile/reorder_python_imports"
  url "https://files.pythonhosted.org/packages/b2/fc/b40752aea4b6621a271dd655c6f537c1156a4d7956c6bf87b8c2d2f2eb08/reorder_python_imports-3.8.0.tar.gz"
  sha256 "02347ada22bc8502d2a2e71bd4da626ac0a8044d61c3246e97d99622e9ed25e9"
  license "MIT"
  head "https://github.com/asottile/reorder_python_imports.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f375263caecc526d36eec67a633b60a9637bb9ecab259d7be9424553cfa3875"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2f375263caecc526d36eec67a633b60a9637bb9ecab259d7be9424553cfa3875"
    sha256 cellar: :any_skip_relocation, monterey:       "33549ea0ddf087795bee2806872efb9e4f8c424da0a52a8dfed4ccb365d02bf8"
    sha256 cellar: :any_skip_relocation, big_sur:        "33549ea0ddf087795bee2806872efb9e4f8c424da0a52a8dfed4ccb365d02bf8"
    sha256 cellar: :any_skip_relocation, catalina:       "33549ea0ddf087795bee2806872efb9e4f8c424da0a52a8dfed4ccb365d02bf8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e79bdd281678da4b336c0560657e26ac1045147784378a37cb4929576ae7f56"
  end

  depends_on "python@3.10"

  resource "classify-imports" do
    url "https://files.pythonhosted.org/packages/5e/b1/5c8792dee3437a13d66e0518bcd6add8ec6f54a02c89ef3f14986a05016d/classify_imports-4.1.0.tar.gz"
    sha256 "69ddc4320690c26aa8baa66bf7e0fa0eecfda49d99cf71a59dee0b57dac82616"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.py").write <<~EOS
      from os import path
      import sys
    EOS
    system "#{bin}/reorder-python-imports", "--exit-zero-even-if-changed", "#{testpath}/test.py"
    assert_equal("import sys\nfrom os import path\n", File.read(testpath/"test.py"))
  end
end
