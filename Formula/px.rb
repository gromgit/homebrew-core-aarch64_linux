class Px < Formula
  include Language::Python::Virtualenv

  desc "Ps and top for human beings (px / ptop)"
  homepage "https://github.com/walles/px"
  url "https://github.com/walles/px.git",
      tag:      "1.6.1",
      revision: "e513e51de56d581b8ea1483acebf24547caec86d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b6653071bb98eaa87a49e21f74d1a66534728c7b88f9026abac1394ac19d40c8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "020d13cfcd9a92910690cd07bfd73f49c6cf9c518677a262e970e49d35d8ce7e"
    sha256 cellar: :any_skip_relocation, monterey:       "29354d30cc92b374eb202cfc7bfa605b332097a49f918dcd1e72ae2259e8a6ab"
    sha256 cellar: :any_skip_relocation, big_sur:        "6cbae0b3ea3c40c3821db04c9e2f0e99f1bb1405a928f40066b747514ace1717"
    sha256 cellar: :any_skip_relocation, catalina:       "ba0ecd9d3cf4945edba0401670f3547dbb300472b89501c18a8d2ee1fc103e5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7cd5ff52f8c29be19033800c6219643c11788abc08db3c6457dc194f5664cd7e"
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
