class Codespell < Formula
  include Language::Python::Virtualenv

  desc "Fix common misspellings in source code and text files"
  homepage "https://github.com/codespell-project/codespell"
  url "https://files.pythonhosted.org/packages/f2/2e/26fe0d3adc937f08e72930d9155bb5b7e07f5ca98b5f01e44a789407cd1e/codespell-2.2.0.tar.gz"
  sha256 "3dce0cd1348d277f8d934d1d4dcbbf510f9ddfd1b9005e9b25fb983189962561"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f5ed3ef1ac934163c536913b4fb6fbb951dc5f38f93a4cb4749ba3d3e6aab8f0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f5ed3ef1ac934163c536913b4fb6fbb951dc5f38f93a4cb4749ba3d3e6aab8f0"
    sha256 cellar: :any_skip_relocation, monterey:       "62206663f00a9d7ae69a73ae0d9a676a90489d7cb042e5625bec4ed6615f74ac"
    sha256 cellar: :any_skip_relocation, big_sur:        "62206663f00a9d7ae69a73ae0d9a676a90489d7cb042e5625bec4ed6615f74ac"
    sha256 cellar: :any_skip_relocation, catalina:       "62206663f00a9d7ae69a73ae0d9a676a90489d7cb042e5625bec4ed6615f74ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d19d76f66af0966c91355d0abbbe750e6db25fbd778cbdb138b6eafb9ca6c732"
  end

  depends_on "python@3.10"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal "1: teh\n\tteh ==> the\n", pipe_output("#{bin}/codespell -", "teh", 65)
  end
end
