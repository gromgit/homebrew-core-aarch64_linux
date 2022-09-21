class Nikto < Formula
  desc "Web server scanner"
  homepage "https://cirt.net/nikto2"
  url "https://github.com/sullo/nikto/archive/2.1.6.tar.gz"
  sha256 "c1731ae4133d3879718bb7605a8d395b2036668505effbcbbcaa4dae4e9f27f2"
  license "GPL-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/nikto"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "810259bf882ce941222f492ff14622b550794e74e3181c32568a663239f8b1a9"
  end

  def install
    cd "program" do
      inreplace "nikto.pl", "/etc/nikto.conf", "#{etc}/nikto.conf"

      inreplace "nikto.conf" do |s|
        s.gsub! "# EXECDIR=/opt/nikto", "EXECDIR=#{prefix}"
        s.gsub! "# PLUGINDIR=/opt/nikto/plugins",
                "PLUGINDIR=#{pkgshare}/plugins"
        s.gsub! "# DBDIR=/opt/nikto/databases",
                "DBDIR=#{var}/lib/nikto/databases"
        s.gsub! "# TEMPLATEDIR=/opt/nikto/templates",
                "TEMPLATEDIR=#{pkgshare}/templates"
        s.gsub! "# DOCDIR=/opt/nikto/docs", "DOCDIR=#{pkgshare}/docs"
      end

      bin.install "nikto.pl" => "nikto"
      bin.install "replay.pl"
      etc.install "nikto.conf"
      man1.install "docs/nikto.1"
      pkgshare.install "docs", "plugins", "templates"
    end

    doc.install Dir["documentation/*"]
    (var/"lib/nikto/databases").mkpath
    cp_r Dir["program/databases/*"], var/"lib/nikto/databases"
  end

  test do
    system bin/"nikto", "-H"
  end
end
