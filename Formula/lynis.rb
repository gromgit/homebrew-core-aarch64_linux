class Lynis < Formula
  desc "Security and system auditing tool to harden systems"
  homepage "https://cisofy.com/lynis/"
  url "https://github.com/CISOfy/lynis/archive/3.0.4.tar.gz"
  sha256 "727ba184d0670f9ea9c43077afd6faa7f718e5c069b8588098a82db8a2e1f6ea"
  license "GPL-3.0-only"

  livecheck do
    url "https://cisofy.com/downloads/lynis/"
    regex(%r{href=.*?/lynis[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a22fbdbfc60985e0a634cbef0b4083666064b8e314ed79c2773f145204235ea5"
    sha256 cellar: :any_skip_relocation, big_sur:       "d22239d086c798e7836147217ee7f60488275300bea1a3132d862a06b0c7ab9e"
    sha256 cellar: :any_skip_relocation, catalina:      "d22239d086c798e7836147217ee7f60488275300bea1a3132d862a06b0c7ab9e"
    sha256 cellar: :any_skip_relocation, mojave:        "d22239d086c798e7836147217ee7f60488275300bea1a3132d862a06b0c7ab9e"
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
