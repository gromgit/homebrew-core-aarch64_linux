class ArxivLatexCleaner < Formula
  include Language::Python::Virtualenv

  desc "Clean LaTeX code to submit to arXiv"
  homepage "https://github.com/google-research/arxiv-latex-cleaner"
  url "https://files.pythonhosted.org/packages/ab/4c/a06ba3d1bc19c0c4f3215db8534582c9d5d096ff18948e0576d10ec8fe65/arxiv_latex_cleaner-0.1.29.tar.gz"
  sha256 "9f74f4d7baa59d1a0cbc7d80bc2bb9005e975e04374273e81a2370de23879885"
  license "Apache-2.0"
  head "https://github.com/google-research/arxiv-latex-cleaner.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bfacf14fff528d8c54bcc9a0d3598523f1a9bb23270824455ff79a84d2615ed4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bfacf14fff528d8c54bcc9a0d3598523f1a9bb23270824455ff79a84d2615ed4"
    sha256 cellar: :any_skip_relocation, monterey:       "89fae052f2b4e327b8c2a52965687a44101be22aab803ede33cc90e94b6cbfe0"
    sha256 cellar: :any_skip_relocation, big_sur:        "89fae052f2b4e327b8c2a52965687a44101be22aab803ede33cc90e94b6cbfe0"
    sha256 cellar: :any_skip_relocation, catalina:       "89fae052f2b4e327b8c2a52965687a44101be22aab803ede33cc90e94b6cbfe0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04e753a0d424d3855fac07e4ee0850119df040f6e179ee629f8639a8224f2449"
  end

  depends_on "pillow"
  depends_on "python@3.10"
  depends_on "pyyaml"
  depends_on "six"

  resource "absl-py" do
    url "https://files.pythonhosted.org/packages/20/5b/02495cbb35e658e8353e309a288efcb93b3ca3cbb87a47db49d6c6516961/absl-py-1.2.0.tar.gz"
    sha256 "f568809938c49abbda89826223c992b630afd23c638160ad7840cfe347710d97"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/f8/43/b85d103acc0bfb54939f801908bf83354085579e8422eeaa22c017950c02/regex-2022.9.13.tar.gz"
    sha256 "f07373b6e56a6f3a0df3d75b651a278ca7bd357a796078a26a958ea1ce0588fd"
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
