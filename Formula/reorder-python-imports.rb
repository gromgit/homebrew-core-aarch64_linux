class ReorderPythonImports < Formula
  include Language::Python::Virtualenv

  desc "Rewrites source to reorder python imports"
  homepage "https://github.com/asottile/reorder_python_imports"
  url "https://github.com/asottile/reorder_python_imports/archive/v2.3.6.tar.gz"
  sha256 "33df7db05db1557c743ddb3fe24cbf2d5d29bb56c3e42cb41383a242c8a213db"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "8a46ea15899ccd66b9ce3778f8a655e42317c6e656e5f9d9c781c8078c1c2769" => :catalina
    sha256 "688e50c273fc03cc99b0ed5670dd7b21bfbc49c6a67e401ea87f8efb6342b0b4" => :mojave
    sha256 "eaba68481ccf5c4272ef4b29e46aea5e14875c767d1fb951004c5070dd534f8f" => :high_sierra
  end

  depends_on "python@3.9"

  resource "aspy.refactor-imports" do
    url "https://files.pythonhosted.org/packages/34/6e/37cbfba703b06fca29c38079bef76cc01e8496197701fff8f0dded3b5b38/aspy.refactor_imports-2.1.1.tar.gz"
    sha256 "eec8d1a73bedf64ffb8b589ad919a030c1fb14acf7d1ce0ab192f6eedae895c5"
  end

  resource "cached-property" do
    url "https://files.pythonhosted.org/packages/61/2c/d21c1c23c2895c091fa7a91a54b6872098fea913526932d21902088a7c41/cached-property-1.5.2.tar.gz"
    sha256 "9fa5755838eecbb2d234c3aa390bd80fbd3ac6b6869109bfc1b499f7bd89a130"
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
