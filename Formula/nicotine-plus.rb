class NicotinePlus < Formula
  include Language::Python::Virtualenv

  desc "Graphical client for the Soulseek file sharing network"
  homepage "https://nicotine-plus.github.io/nicotine-plus/"
  url "https://files.pythonhosted.org/packages/87/0e/803cd7362970056d8e8f824b47ce6a73227c91021fbe27e79737735e5d7d/nicotine-plus-3.2.3.tar.gz"
  sha256 "3facd5984f219e6c3fc8b3011ff6f8788d7c8b08fccdbd89e08d96694f0b2b8e"
  license "GPL-3.0-or-later"
  head "https://github.com/Nicotine-Plus/nicotine-plus.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6194d10d3f3f39b1880feda41871dc49807bdbecda5f970a2b2e4458f6b6f277"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6194d10d3f3f39b1880feda41871dc49807bdbecda5f970a2b2e4458f6b6f277"
    sha256 cellar: :any_skip_relocation, monterey:       "a638c716a0a81cdfec07a94f5be1b7f1860e16a0461869d0e6c26ff573dc46fb"
    sha256 cellar: :any_skip_relocation, big_sur:        "a638c716a0a81cdfec07a94f5be1b7f1860e16a0461869d0e6c26ff573dc46fb"
    sha256 cellar: :any_skip_relocation, catalina:       "a638c716a0a81cdfec07a94f5be1b7f1860e16a0461869d0e6c26ff573dc46fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "abe8c4a3246a77d9331c0c8ea8e6b69d02f76d0d4dcb9e64fb79e43e5e8de9d7"
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
