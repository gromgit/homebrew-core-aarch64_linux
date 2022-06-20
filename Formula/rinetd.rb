class Rinetd < Formula
  desc "Internet TCP redirection server"
  homepage "https://github.com/samhocevar/rinetd"
  url "https://github.com/samhocevar/rinetd/releases/download/v0.73/rinetd-0.73.tar.bz2"
  sha256 "24dd6ec1c4d353c33ced775a37566af9565b27e65f3e59939a8b2913a92c81d2"
  license "GPL-2.0-or-later"
  # NOTE: Original (unversioned) tool is at https://github.com/boutell/rinetd
  #       Debian tracks the "samhocevar" fork so we follow suit
  head "https://github.com/samhocevar/rinetd.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/rinetd"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "edab9db633e1a1afb079211481407ad81e4e0c44f6f9f7129b684ffa932c3652"
  end

  def install
    # The daemon() function does exist but its deprecated so keep configure
    # away:
    system "./configure", "--prefix=#{prefix}", "--sysconfdir=#{share}", "ac_cv_func_daemon=no"

    # Point hardcoded runtime paths inside of our prefix
    inreplace "src/rinetd.h" do |s|
      s.gsub! "/etc/rinetd.conf", "#{etc}/rinetd.conf"
      s.gsub! "/var/run/rinetd.pid", "#{var}/run/rinetd.pid"
    end
    inreplace "rinetd.conf", "/var/log", "#{var}/log"

    # Install conf file only as example and have post_install put it into place
    mv "rinetd.conf", "rinetd.conf.example"
    inreplace "Makefile", "rinetd.conf", "rinetd.conf.example"

    system "make", "install"
  end

  def post_install
    conf = etc/"rinetd.conf"
    cp "#{share}/rinetd.conf.example", conf unless conf.exist?
  end

  test do
    system "#{sbin}/rinetd", "-h"
  end
end
