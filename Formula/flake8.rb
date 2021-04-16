class Flake8 < Formula
  include Language::Python::Virtualenv

  desc "Lint your Python code for style and logical errors"
  homepage "https://flake8.pycqa.org/"
  url "https://files.pythonhosted.org/packages/6f/83/dc61838e86f8da660f473db2193614120994de0f33673688da76de0d16bf/flake8-3.9.1.tar.gz"
  sha256 "1aa8990be1e689d96c745c5682b687ea49f2e05a443aff1f8251092b0014e378"
  license "MIT"
  head "https://gitlab.com/PyCQA/flake8.git", shallow: false

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "21984464d73424bf014891c85318682610e5f6d975e5df18c3f5107937e6cd51"
    sha256 cellar: :any_skip_relocation, big_sur:       "8d8886893eb6326f968b8adc0e9cb863329012903dbefe0ee251a9d5e861f10b"
    sha256 cellar: :any_skip_relocation, catalina:      "c800bc9078ba5dfe566d3d52055089c3c59cd42729a1580e4884b94b9669d0bd"
    sha256 cellar: :any_skip_relocation, mojave:        "8773e31daeb655f6fc113e939de4a796f67fdb614324aa2cd965a082f3bdb151"
  end

  depends_on "python@3.9"

  resource "mccabe" do
    url "https://files.pythonhosted.org/packages/06/18/fa675aa501e11d6d6ca0ae73a101b2f3571a565e0f7d38e062eec18a91ee/mccabe-0.6.1.tar.gz"
    sha256 "dd8d182285a0fe56bace7f45b5e7d1a6ebcbf524e8f3bd87eb0f125271b8831f"
  end

  resource "pycodestyle" do
    url "https://files.pythonhosted.org/packages/02/b3/c832123f2699892c715fcdfebb1a8fdeffa11bb7b2350e46ecdd76b45a20/pycodestyle-2.7.0.tar.gz"
    sha256 "c389c1d06bf7904078ca03399a4816f974a1d590090fecea0c63ec26ebaf1cef"
  end

  resource "pyflakes" do
    url "https://files.pythonhosted.org/packages/a8/0f/0dc480da9162749bf629dca76570972dd9cce5bedc60196a3c912875c87d/pyflakes-2.3.1.tar.gz"
    sha256 "f5bc8ecabc05bb9d291eb5203d6810b49040f6ff446a756326104746cc00c1db"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test-bad.py").write <<~EOS
      print ("Hello World!")
    EOS

    (testpath/"test-good.py").write <<~EOS
      print("Hello World!")
    EOS

    assert_match "E211", shell_output("#{bin}/flake8 test-bad.py", 1)
    assert_empty shell_output("#{bin}/flake8 test-good.py")
  end
end
