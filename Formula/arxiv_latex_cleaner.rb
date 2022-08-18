class ArxivLatexCleaner < Formula
  include Language::Python::Virtualenv

  desc "Clean LaTeX code to submit to arXiv"
  homepage "https://github.com/google-research/arxiv-latex-cleaner"
  url "https://files.pythonhosted.org/packages/b8/4d/58a34098d023513ad129891799685c0f28387c4be22e72abbebed5a649ca/arxiv_latex_cleaner-0.1.28.tar.gz"
  sha256 "9bb9ab3a965ad3cbb394fdd288f1d675ae1c9e2e4c1839337903fcd567ef74e8"
  license "Apache-2.0"
  head "https://github.com/google-research/arxiv-latex-cleaner.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5441f70ccea6d9b3ffd638033d8cf2e8609e78d0aaa9e7dcff9f382f4140a375"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b256803dfc16800f44a88a9aef6894d58b561a5410e22460fcfb8b6044c20d6b"
    sha256 cellar: :any_skip_relocation, monterey:       "c200561a2a3e02041b4cd300bec52e57ad81d7d2b965e643737c9a2244a50263"
    sha256 cellar: :any_skip_relocation, big_sur:        "2c5665c97d71b72cc0e82891152e462e4f5c7d01e6b236837954029a10c6738c"
    sha256 cellar: :any_skip_relocation, catalina:       "2115095231b656a8656fa42378506044cea424b91636e6ead1ffed17a32d2777"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a2ad9b172ca1a62c29283d8f0e155c30d0cd30aec072a47a1215dbe2fc15a9d"
  end

  depends_on "pillow"
  depends_on "python@3.10"
  depends_on "six"

  resource "absl-py" do
    url "https://files.pythonhosted.org/packages/20/5b/02495cbb35e658e8353e309a288efcb93b3ca3cbb87a47db49d6c6516961/absl-py-1.2.0.tar.gz"
    sha256 "f568809938c49abbda89826223c992b630afd23c638160ad7840cfe347710d97"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/36/2b/61d51a2c4f25ef062ae3f74576b01638bebad5e045f747ff12643df63844/PyYAML-6.0.tar.gz"
    sha256 "68fb519c14306fec9720a2a5b45bc9f0c8d1b9c72adf45c37baedfcd949c35a2"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    latexdir = testpath/"latex"
    latexdir.mkpath
    (latexdir/"test.tex").write <<~EOS
      % remove
      keep
    EOS
    system bin/"arxiv_latex_cleaner", latexdir
    assert_predicate testpath/"latex_arXiv", :exist?
    assert_equal "keep", (testpath/"latex_arXiv/test.tex").read.strip
  end
end
