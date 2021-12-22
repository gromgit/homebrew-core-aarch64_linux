class Px < Formula
  include Language::Python::Virtualenv

  desc "Ps and top for human beings (px / ptop)"
  homepage "https://github.com/walles/px"
  url "https://github.com/walles/px.git",
      tag:      "1.6.0",
      revision: "724efee22505c7f2cadf9f72801ef11a011fa0a6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c2d2465d209457797ba2839814ff828c987e07412c23b455a2a7b1e73515a32"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0b38d2cc9d6c7cf0b3f8d21bd7c50b98d5bbb9f4d7378752c09f284a7259950f"
    sha256 cellar: :any_skip_relocation, monterey:       "dc2e4f7f9eb7e521a8cd1e722ee855b02f3efcb189e6981ce32e01868265d5ff"
    sha256 cellar: :any_skip_relocation, big_sur:        "5f44f0b051285a764d39d002855bdb699b4a2e210e79e2733a90834b8fc341d7"
    sha256 cellar: :any_skip_relocation, catalina:       "c9b93e1b3700144ec1b713a948928df21af672d6fa7aec5c84469168ab3a9330"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d828390324ec05054f8a1acc8dc4186f1867426dd235f55e551e75b5a3dbbe4"
  end

  depends_on "python@3.10"
  depends_on "six"

  uses_from_macos "lsof"

  # For updates: https://pypi.org/project/python-dateutil/#files
  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    split_first_line = pipe_output("#{bin}/px --no-pager").lines.first.split
    assert_equal %w[PID COMMAND USERNAME CPU CPUTIME RAM COMMANDLINE], split_first_line
  end
end
