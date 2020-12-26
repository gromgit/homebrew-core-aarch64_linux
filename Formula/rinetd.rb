class Rinetd < Formula
  desc "Internet TCP redirection server"
  homepage "https://github.com/samhocevar/rinetd"
  url "https://github.com/samhocevar/rinetd/releases/download/v0.70/rinetd-0.70.tar.bz2"
  sha256 "cefe9115c57fe5ec98d735f6421f30c461192e345a46ef644857b11fa6c5fccb"
  license "GPL-2.0-or-later"
  # NOTE: Original (unversioned) tool is at https://github.com/boutell/rinetd
  #       Debian tracks the "samhocevar" fork so we follow suit
  head "https://github.com/samhocevar/rinetd"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "1c12b89085411d90b1ee003b06f64208235210e01ad1cd940706d7663bd2dbce" => :big_sur
    sha256 "7f4dd364eba5c14a1de1901b9ec08d072165d308110912838127d1fd4e293732" => :catalina
    sha256 "f2afbf352dcf6cd00b5636ca486f0d8542e4af3d047e144e0ba409c6f828ffcd" => :mojave
  end

  def install
    # The daemon() function does exist but its deprecated so keep configure
    # away:
    system "./configure", "--prefix=#{prefix}", "--sysconfdir=#{share}", "ac_cv_func_daemon=no"

    # Point hardcoded runtime paths inside of our prefix
    inreplace "rinetd.h" do |s|
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
