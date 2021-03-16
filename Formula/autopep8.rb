class Autopep8 < Formula
  include Language::Python::Virtualenv

  desc "Automatically formats Python code to conform to the PEP 8 style guide"
  homepage "https://github.com/hhatto/autopep8"
  url "https://files.pythonhosted.org/packages/96/a5/d282540e6e0ea8a3fd58edaf97eff1d787e56787e5bf6c70f670aaedef7a/autopep8-1.5.6.tar.gz"
  sha256 "5454e6e9a3d02aae38f866eec0d9a7de4ab9f93c10a273fb0340f3d6d09f7514"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "abf487f3114b67ebfe0760421a3df96e948fbcb2ec378cd2fcab08e2d73aaf49"
    sha256 cellar: :any_skip_relocation, big_sur:       "0d9286b07276cd78d5fb31ed9bd126b5675ffb9b8509793f17d49a571e44b49b"
    sha256 cellar: :any_skip_relocation, catalina:      "7445d78c6c97dad32d841a2afaa2f655d1514b72eca5650460d1d1a8f175e1fe"
    sha256 cellar: :any_skip_relocation, mojave:        "b3ea685a6f92eb1c2b283a38c54a1155fe06fc3f0f7374c8a99ffcbd483286c8"
  end

  depends_on "python@3.9"

  resource "pycodestyle" do
    url "https://files.pythonhosted.org/packages/02/b3/c832123f2699892c715fcdfebb1a8fdeffa11bb7b2350e46ecdd76b45a20/pycodestyle-2.7.0.tar.gz"
    sha256 "c389c1d06bf7904078ca03399a4816f974a1d590090fecea0c63ec26ebaf1cef"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("echo \"x='homebrew'\" | #{bin}/autopep8 -")
    assert_equal "x = 'homebrew'", output.strip
  end
end
