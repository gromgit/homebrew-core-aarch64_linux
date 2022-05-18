class Lynis < Formula
  desc "Security and system auditing tool to harden systems"
  homepage "https://cisofy.com/lynis/"
  url "https://github.com/CISOfy/lynis/archive/3.0.8.tar.gz"
  sha256 "0315da29e382281daa1db24c8494ca12659c7387d9cd30222adcf1aa01383730"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c78dbc7b8b2eae1662939c4be89c5d491e94cb351775f720055fc0033f55465"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3c78dbc7b8b2eae1662939c4be89c5d491e94cb351775f720055fc0033f55465"
    sha256 cellar: :any_skip_relocation, monterey:       "37a7777dfd2d2a662fcbc04ecf7c5a756d52bb862355d7f7ef0908ee43e52478"
    sha256 cellar: :any_skip_relocation, big_sur:        "37a7777dfd2d2a662fcbc04ecf7c5a756d52bb862355d7f7ef0908ee43e52478"
    sha256 cellar: :any_skip_relocation, catalina:       "37a7777dfd2d2a662fcbc04ecf7c5a756d52bb862355d7f7ef0908ee43e52478"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c78dbc7b8b2eae1662939c4be89c5d491e94cb351775f720055fc0033f55465"
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
