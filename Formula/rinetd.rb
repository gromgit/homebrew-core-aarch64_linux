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
    rebuild 1
    sha256 "d13c2114ebe94b503d90069ef1394894e4b8c02c151c7f87f67de6e19c385e1e" => :catalina
    sha256 "fe8636ee77c709a3a2df599058c59d7cdbaaa6505fa42e9bac143af95c0c835c" => :mojave
    sha256 "44750b361b999c09a17a2bc8c576585a790c42bee66abe4df191b7b0cafe304c" => :high_sierra
    sha256 "7a52fc5d01d83fd186626a6cff981e65da8943186973a4314efa2c561480325e" => :sierra
    sha256 "30c72c1a5764aa20e7d8e232bcfe979f138e5029966c43468a886481304c39cb" => :el_capitan
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
