class PythonMarkdown < Formula
  include Language::Python::Virtualenv

  desc "Python implementation of Markdown"
  homepage "https://python-markdown.github.io"
  url "https://files.pythonhosted.org/packages/49/02/37bd82ae255bb4dfef97a4b32d95906187b7a7a74970761fca1360c4ba22/Markdown-3.3.4.tar.gz"
  sha256 "31b5b491868dcc87d6c24b7e3d19a0d730d59d3e46f4eea6430a321bed387a49"
  license "BSD-3-Clause"
  head "https://github.com/Python-Markdown/markdown.git"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e15c00fbbc97ddc7727ed969fa6b66e39d14a0840c701a278cc7d936265b3820"
    sha256 cellar: :any_skip_relocation, big_sur:       "5c0eca089cf51f1a18fa14b08ef2e453940d216bd28c971c1e32c1d92dc924c8"
    sha256 cellar: :any_skip_relocation, catalina:      "2a5f0bc6b8f4e8f8910b638ca9de6d78d1721c670a58b04e85843e486f91b321"
    sha256 cellar: :any_skip_relocation, mojave:        "800ed7fb5c992646e2f6486eeb369b41a35f38f6aa1b219f91535ebb7817b755"
  end

  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.md").write("# Hello World!")
    assert_equal "<h1>Hello World!</h1>", shell_output(bin/"markdown_py test.md").strip
  end
end
