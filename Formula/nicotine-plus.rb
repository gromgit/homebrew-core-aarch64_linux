class NicotinePlus < Formula
  include Language::Python::Virtualenv

  desc "Graphical client for the Soulseek file sharing network"
  homepage "https://nicotine-plus.github.io/nicotine-plus/"
  url "https://files.pythonhosted.org/packages/90/7e/4f7a0b949998ce2bbfa9860a5f3ed74fa080c816501d5126e4cbec716c9d/nicotine-plus-3.1.0.tar.gz"
  sha256 "afa8033d4c07a58e79e0998fdd41d2f1fd5f93b196fdf76f1822639efd0b60b8"
  license "GPL-3.0-or-later"
  head "https://github.com/Nicotine-Plus/nicotine-plus.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e972743e2f54137fa86daee847c43303eb90753c67a7d3dae780399413b39627"
    sha256 cellar: :any_skip_relocation, big_sur:       "8911f1a7dcf2871ec7bcb515874b0a35508d95a52077d660284b8593e19b5e24"
    sha256 cellar: :any_skip_relocation, catalina:      "8911f1a7dcf2871ec7bcb515874b0a35508d95a52077d660284b8593e19b5e24"
    sha256 cellar: :any_skip_relocation, mojave:        "8911f1a7dcf2871ec7bcb515874b0a35508d95a52077d660284b8593e19b5e24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a7c553b10e2f176f180e33f75f55ca0eb64b8f93f77667383f2d76f83cbde65"
  end

  depends_on "adwaita-icon-theme"
  depends_on "gtk+3"
  depends_on "py3cairo"
  depends_on "pygobject3"
  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nicotine -v")
    pid = fork do
      exec bin/"nicotine", "-s"
    end
    sleep 3
    Process.kill("TERM", pid)
  end
end
