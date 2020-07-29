class ReorderPythonImports < Formula
  include Language::Python::Virtualenv

  desc "Rewrites source to reorder python imports"
  homepage "https://github.com/asottile/reorder_python_imports"
  url "https://github.com/asottile/reorder_python_imports/archive/v2.3.4.tar.gz"
  sha256 "238b6586e336667d0dfcc64654ed64847e0cb600a21edaab478ff5fd299d1c55"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "4b3ff9c0f690350354bd60aa6f6e5c75dafcf09e59ca0f4ced5b93dba2fb39b2" => :catalina
    sha256 "bc08c6a33c78e510100b836929d7b165a3ce2b564a6b50008d086803e501e579" => :mojave
    sha256 "c866fcd422a28870131a0392733bab6cf231fb88665b4bf2c9ebf7b75d4990dc" => :high_sierra
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
