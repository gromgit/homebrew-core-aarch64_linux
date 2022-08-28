class TrashCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to the freedesktop.org trashcan"
  homepage "https://github.com/andreafrancia/trash-cli"
  url "https://files.pythonhosted.org/packages/ce/93/62fa6fcf583c61f1ce21e1efaa0509729a72f9f1ebbf5f3664e16779ed00/trash-cli-0.22.8.27.tar.gz"
  sha256 "b2799ed134c3fb2880fed12995ac9d9937466d86ff84936c16408f8d5778737b"
  license "GPL-2.0-or-later"
  head "https://github.com/andreafrancia/trash-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b80c2a8f0ae5fc6988752c7412cd1c871bce83ca45ed9c503a4418ae81aa99e3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3c224c39d66d68481d17b38a335a5e691b71b1bac34f44e17a87f0d1ad23d3b7"
    sha256 cellar: :any_skip_relocation, monterey:       "196511eee07b681da088e4f772535eb2160888c17ee691f5214f75eead774ea2"
    sha256 cellar: :any_skip_relocation, big_sur:        "de7f8249496d460760b21216f559d4b437b1e41b1d45efffd7e7ca1eb143392f"
    sha256 cellar: :any_skip_relocation, catalina:       "8106839f9402b59c7c68c21b8e6ed0c7f779dbe1252cdc363474323e643ae792"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4d5e9a1bb0af0be9ab8bfcbda19444b071e1dff5f27c19c6c83e9ad1c372962"
  end

  depends_on "python@3.10"

  conflicts_with "macos-trash", because: "both install a `trash` binary"
  conflicts_with "trash", because: "both install a `trash` binary"

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/d6/de/0999ea2562b96d7165812606b18f7169307b60cd378bc29cf3673322c7e9/psutil-5.9.1.tar.gz"
    sha256 "57f1819b5d9e95cdfb0c881a8a5b7d542ed0b7c522d575706a80bedc848c8954"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    touch "testfile"
    assert_predicate testpath/"testfile", :exist?
    system bin/"trash-put", "testfile"
    refute_predicate testpath/"testfile", :exist?
  end
end
