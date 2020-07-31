class ReorderPythonImports < Formula
  include Language::Python::Virtualenv

  desc "Rewrites source to reorder python imports"
  homepage "https://github.com/asottile/reorder_python_imports"
  url "https://github.com/asottile/reorder_python_imports/archive/v2.3.5.tar.gz"
  sha256 "e5c5b77efbd3a61fc2a4ab1ad36c57445dbec4313b8177725ead98ae05f8426e"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "7356f526bee0a17d233ce5a174fac6bc26b018888142fbe29306553edf8472e2" => :catalina
    sha256 "df9181bf185db5aac4d20f1c6958007918ad432ae7ee94e6a58f2d1fc14d20c2" => :mojave
    sha256 "4304a03eb06e464b8464535b98352ece430eaac271ebfe0db9a863e70d624aa7" => :high_sierra
  end

  depends_on "python@3.8"

  resource "aspy.refactor-imports" do
    url "https://files.pythonhosted.org/packages/34/6e/37cbfba703b06fca29c38079bef76cc01e8496197701fff8f0dded3b5b38/aspy.refactor_imports-2.1.1.tar.gz"
    sha256 "eec8d1a73bedf64ffb8b589ad919a030c1fb14acf7d1ce0ab192f6eedae895c5"
  end

  resource "cached-property" do
    url "https://files.pythonhosted.org/packages/57/8e/0698e10350a57d46b3bcfe8eff1d4181642fd1724073336079cb13c5cf7f/cached-property-1.5.1.tar.gz"
    sha256 "9217a59f14a5682da7c4b8829deadbfc194ac22e9908ccf7c8820234e80a1504"
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
