class NicotinePlus < Formula
  include Language::Python::Virtualenv

  desc "Graphical client for the Soulseek file sharing network"
  homepage "https://nicotine-plus.github.io/nicotine-plus/"
  url "https://files.pythonhosted.org/packages/8d/60/a0a7b9d9066a4edcc4b9965d71e31794fc5faf2f8624619d46a8c484d272/nicotine-plus-3.2.2.tar.gz"
  sha256 "32bb50559bb67b0b6d1760d4a11eec0660f841d00607a1f165292c967b6001c9"
  license "GPL-3.0-or-later"
  head "https://github.com/Nicotine-Plus/nicotine-plus.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "818ac9f1abfabc01664014a9adb46cbbc461574f367b19304a3ce6d632db3d1f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "818ac9f1abfabc01664014a9adb46cbbc461574f367b19304a3ce6d632db3d1f"
    sha256 cellar: :any_skip_relocation, monterey:       "635b98a5568c1ff49fd0b4e9bf741b363f35a96252fc246bb445e7ca2ccfb698"
    sha256 cellar: :any_skip_relocation, big_sur:        "635b98a5568c1ff49fd0b4e9bf741b363f35a96252fc246bb445e7ca2ccfb698"
    sha256 cellar: :any_skip_relocation, catalina:       "635b98a5568c1ff49fd0b4e9bf741b363f35a96252fc246bb445e7ca2ccfb698"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ee4773eb5fbbbd4284ce16a7fcffc7396bc917ca3b92c21d626277f9c11624b"
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
