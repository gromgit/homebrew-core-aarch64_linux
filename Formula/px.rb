class Px < Formula
  include Language::Python::Virtualenv

  desc "Ps and top for human beings (px / ptop)"
  homepage "https://github.com/walles/px"
  url "https://github.com/walles/px.git",
      tag:      "1.4.0",
      revision: "aea41c2a67a8b83e644e11d8ac152e2c123d0ee1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d7e2be47d32349f708eeda8ddfa0de14ecc1f5097843b6717afc73087be1b164"
    sha256 cellar: :any_skip_relocation, big_sur:       "4ea324770c4222519f8bb6b4c73b5fa4e28269fcb5b090fec5b7225d8345f45b"
    sha256 cellar: :any_skip_relocation, catalina:      "2f642acd87d987208873406708253959f554722d68061aa3a4a7fb5d8c296d4c"
    sha256 cellar: :any_skip_relocation, mojave:        "10957e4df4bb14fcab4bc4dd3437f0051eab9a9a1f4d7d61f732f3651f06cb1e"
  end

  depends_on "python@3.9"
  depends_on "six"

  uses_from_macos "lsof"

  # For updates: https://pypi.org/project/python-dateutil/#files
  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/be/ed/5bbc91f03fa4c839c4c7360375da77f9659af5f7086b7a7bdda65771c8e0/python-dateutil-2.8.1.tar.gz"
    sha256 "73ebfe9dbf22e832286dafa60473e4cd239f8592f699aa5adaf10050e6e1823c"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    split_first_line = pipe_output("#{bin}/px --no-pager").lines.first.split
    assert_equal %w[PID COMMAND USERNAME CPU CPUTIME RAM COMMANDLINE], split_first_line
  end
end
