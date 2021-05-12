class PyqtBuilder < Formula
  include Language::Python::Virtualenv

  desc "Tool to build PyQt"
  homepage "https://www.riverbankcomputing.com/software/pyqt-builder/intro"
  url "https://files.pythonhosted.org/packages/12/29/af52add4755b7dbce928fe3df1b86a48d5c8bcd06e3333bf8f69ad19c1a5/PyQt-builder-1.10.0.tar.gz"
  sha256 "86bd19fde83d92beaefacdeac1e26c6e1918c300ff78d7ec2a19973bf2cf21b5"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]
  head "https://www.riverbankcomputing.com/hg/PyQt-builder", using: :hg

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b0d8d6f13f30a320c698e0bea28a391c09158e16e08febdfa0432b4fa5f1aa9c"
    sha256 cellar: :any_skip_relocation, big_sur:       "2e4e6416089103fa34a8b8f2f9934d5e24b07c068030c1a3b309c4de8b2289c0"
    sha256 cellar: :any_skip_relocation, catalina:      "7ef4841d49af35ec25619d17bc728cc6b88cc4d2730138d279953222c1b97f95"
    sha256 cellar: :any_skip_relocation, mojave:        "58acbbd35bf0895d23a96be136d3b40cae25d2ef0f90324f65babcaca5f99e71"
  end

  depends_on "python@3.9"
  depends_on "sip"

  def install
    system Formula["python@3.9"].opt_bin/"python3", *Language::Python.setup_install_args(prefix)
  end

  test do
    system bin/"pyqt-bundle", "-V"
    system Formula["python@3.9"].opt_bin/"python3", "-c", "import pyqtbuild"
  end
end
