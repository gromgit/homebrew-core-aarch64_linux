class ReorderPythonImports < Formula
  include Language::Python::Virtualenv

  desc "Rewrites source to reorder python imports"
  homepage "https://github.com/asottile/reorder_python_imports"
  url "https://files.pythonhosted.org/packages/a6/fc/a1cadfac34efd5a0d47993ee5995104aaaa7a42939ac7912c573230942c5/reorder_python_imports-3.3.0.tar.gz"
  sha256 "01fc01665fc51e236f7ef26b080a2134259937dca5ea3aaadac022cb87444f0e"
  license "MIT"
  head "https://github.com/asottile/reorder_python_imports.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9985157573909d811f29ad4d1086ad2dad0f74ca2595968bf4d56679bdc8dec0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9985157573909d811f29ad4d1086ad2dad0f74ca2595968bf4d56679bdc8dec0"
    sha256 cellar: :any_skip_relocation, monterey:       "a14fd3c0d0061f275d207be4cec3dc6f044cf6cd8c980e2fd26500495e1662a2"
    sha256 cellar: :any_skip_relocation, big_sur:        "a14fd3c0d0061f275d207be4cec3dc6f044cf6cd8c980e2fd26500495e1662a2"
    sha256 cellar: :any_skip_relocation, catalina:       "a14fd3c0d0061f275d207be4cec3dc6f044cf6cd8c980e2fd26500495e1662a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "718edd3b574d594d3ffe9f573aefd79f149158fe0f5575486fc989820e46d266"
  end

  depends_on "python@3.10"

  resource "classify-imports" do
    url "https://files.pythonhosted.org/packages/b5/98/9541d3f96f8754ee3f2ecf09f0689fd5d0bb097e769a0b34585425e2d316/classify_imports-4.0.2.tar.gz"
    sha256 "a1880ba36cca1a3e6efc338698685c3c93019c92ecb7cc246636abb42c621e7f"
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
