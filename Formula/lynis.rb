class Lynis < Formula
  desc "Security and system auditing tool to harden systems"
  homepage "https://cisofy.com/lynis/"
  url "https://github.com/CISOfy/lynis/archive/3.0.6.tar.gz"
  sha256 "584ed6f6fa9dedeea1b473d888a4fe92fa9716400284fe41c92aed09cf10ec3e"
  license "GPL-3.0-only"

  livecheck do
    url "https://cisofy.com/downloads/lynis/"
    regex(%r{href=.*?/lynis[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "95cb69f97cc81e243cbe80d8a95088b45350d0255f84e5dd6161261271554ff3"
    sha256 cellar: :any_skip_relocation, big_sur:       "196d3cb1f508777b2773bffa721cb20d41e3b51a3dcf0279a7ad831c64e9d69a"
    sha256 cellar: :any_skip_relocation, catalina:      "196d3cb1f508777b2773bffa721cb20d41e3b51a3dcf0279a7ad831c64e9d69a"
    sha256 cellar: :any_skip_relocation, mojave:        "196d3cb1f508777b2773bffa721cb20d41e3b51a3dcf0279a7ad831c64e9d69a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a30702d97528660fa6d82abcbee4031c466e31950061dcfe7852d07e6f47a364"
  end

  def install
    inreplace "lynis" do |s|
      s.gsub! 'tINCLUDE_TARGETS="/usr/local/include/lynis ' \
              '/usr/local/lynis/include /usr/share/lynis/include ./include"',
              %Q(tINCLUDE_TARGETS="#{include}")
      s.gsub! 'tPLUGIN_TARGETS="/usr/local/lynis/plugins ' \
              "/usr/local/share/lynis/plugins /usr/share/lynis/plugins " \
              '/etc/lynis/plugins ./plugins"',
              %Q(tPLUGIN_TARGETS="#{prefix}/plugins")
      s.gsub! 'tDB_TARGETS="/usr/local/share/lynis/db /usr/local/lynis/db ' \
              '/usr/share/lynis/db ./db"',
              %Q(tDB_TARGETS="#{prefix}/db")
    end
    inreplace "include/functions" do |s|
      s.gsub! 'tPROFILE_TARGETS="/usr/local/etc/lynis /etc/lynis ' \
              '/usr/local/lynis ."',
              %Q(tPROFILE_TARGETS="#{prefix}")
    end

    prefix.install "db", "include", "plugins", "default.prf"
    bin.install "lynis"
    man8.install "lynis.8"
  end

  test do
    assert_match "lynis", shell_output("#{bin}/lynis --invalid 2>&1", 64)
  end
end
