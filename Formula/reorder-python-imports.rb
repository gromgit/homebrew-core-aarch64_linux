class ReorderPythonImports < Formula
  include Language::Python::Virtualenv

  desc "Rewrites source to reorder python imports"
  homepage "https://github.com/asottile/reorder_python_imports"
  url "https://files.pythonhosted.org/packages/52/c0/319fb92c3784fcf25a000d211cc0bc343d9d1c220b5b8f5a9d66bafb3c0e/reorder_python_imports-3.2.0.tar.gz"
  sha256 "27396162d0262c8680f9a94164bf9eb2914fde09784d97b43978b41aef52d0da"
  license "MIT"
  head "https://github.com/asottile/reorder_python_imports.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c98965317e96edfa7c67452ac13af992c8450b2a389cfb4474f8138a39f04c73"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c98965317e96edfa7c67452ac13af992c8450b2a389cfb4474f8138a39f04c73"
    sha256 cellar: :any_skip_relocation, monterey:       "d57cd0db9645143cb9832659388906ed72100f39c57d209659f88db44660e657"
    sha256 cellar: :any_skip_relocation, big_sur:        "d57cd0db9645143cb9832659388906ed72100f39c57d209659f88db44660e657"
    sha256 cellar: :any_skip_relocation, catalina:       "d57cd0db9645143cb9832659388906ed72100f39c57d209659f88db44660e657"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6b41b8120ba7667f63ca8d0710d6a5279ec1f8ffb50921ac6bde9f49676b2f2"
  end

  depends_on "python@3.10"

  resource "classify-imports" do
    url "https://files.pythonhosted.org/packages/1a/85/401a59cefb79e3446876a479dc2a83de5795915beb9e197b35c1904e374d/classify_imports-4.0.1.tar.gz"
    sha256 "cfee9a3145b9bb4a772ed91047e1710da81e8befa135fdea4bb19c5469a3d5da"
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
