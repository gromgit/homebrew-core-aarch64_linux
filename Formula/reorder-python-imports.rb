class ReorderPythonImports < Formula
  include Language::Python::Virtualenv

  desc "Rewrites source to reorder python imports"
  homepage "https://github.com/asottile/reorder_python_imports"
  url "https://files.pythonhosted.org/packages/57/31/f3367ef663034faa06ef7ff025123d983a6740ce87d87acdc14879071425/reorder_python_imports-3.6.0.tar.gz"
  sha256 "1d77fbd474098966f796ae1b69f04573c08ef87d357525beb8dc5194a9277ba3"
  license "MIT"
  head "https://github.com/asottile/reorder_python_imports.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c412d5b8eccd2e3836c4a8cca7d02cecffc8c684def9fab5c3553e85cee71a67"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c412d5b8eccd2e3836c4a8cca7d02cecffc8c684def9fab5c3553e85cee71a67"
    sha256 cellar: :any_skip_relocation, monterey:       "a7e6bd83b6b00daf40f0daa9580464038157e8cd525bec4c8b8798959d1e478f"
    sha256 cellar: :any_skip_relocation, big_sur:        "a7e6bd83b6b00daf40f0daa9580464038157e8cd525bec4c8b8798959d1e478f"
    sha256 cellar: :any_skip_relocation, catalina:       "a7e6bd83b6b00daf40f0daa9580464038157e8cd525bec4c8b8798959d1e478f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88f0ffc36b12f310185124df70864913cd446d3df9a2539e408348a8c2974576"
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
