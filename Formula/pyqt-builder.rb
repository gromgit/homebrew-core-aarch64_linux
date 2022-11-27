class PyqtBuilder < Formula
  include Language::Python::Virtualenv

  desc "Tool to build PyQt"
  homepage "https://www.riverbankcomputing.com/software/pyqt-builder/intro"
  url "https://files.pythonhosted.org/packages/31/36/6c73f2bd8e4ac5594f6331735951d16d0800f297473db77996966d57cfc7/PyQt-builder-1.13.0.tar.gz"
  sha256 "4877580c38ceb5320e129b381d083b0a8601c68166d8b99707f08fa0a1689eef"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]
  revision 1
  head "https://www.riverbankcomputing.com/hg/PyQt-builder", using: :hg

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/pyqt-builder"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "b53b7d1faca2f2a7bd6842f531cb60b7f1c4c0095232bb1eca1e4ed276d7621e"
  end

  depends_on "python@3.10"
  depends_on "sip"

  def python3
    "python3.10"
  end

  def install
    system Formula["python@3.10"].opt_bin/python3, *Language::Python.setup_install_args(prefix, python3)
  end

  test do
    system bin/"pyqt-bundle", "-V"
    system Formula["python@3.10"].opt_bin/python3, "-c", "import pyqtbuild"
  end
end
