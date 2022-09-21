class Sleepwatcher < Formula
  desc "Monitors sleep, wakeup, and idleness of a Mac"
  homepage "https://www.bernhard-baehr.de/"
  url "https://www.bernhard-baehr.de/sleepwatcher_2.2.1.tgz"
  sha256 "4bf1656702167871141fbc119a844d1363d89994e1a67027f0e773023ae9643e"
  license "GPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?sleepwatcher[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 aarch64_linux: "45492fb95de6a5adad25722737543da5f5b1b1b0a26c1816138fb9b43673ab37" # fake aarch64_linux
  end

  depends_on :macos

  def install
    # Adjust Makefile to build native binary only
    inreplace "sources/Makefile" do |s|
      s.gsub!(/^(CFLAGS)_PPC.*$/, "\\1 = #{ENV.cflags} -prebind")
      s.gsub!(/^(CFLAGS_I386|CFLAGS_X86_64)/, "#\\1")
      s.change_make_var! "BINDIR", "$(PREFIX)/sbin"
      s.change_make_var! "MANDIR", "$(PREFIX)/share/man"
      s.gsub!(/^(.*?)CFLAGS_I386(.*?)[.]i386/, "\\1CFLAGS\\2")
      s.gsub!(/^(.*?CFLAGS_X86_64.*?[.]x86_64)/, "#\\1")
      s.gsub!(/^(\t(lipo|rm).*?[.](i386|x86_64))/, "#\\1")
      s.gsub! "-o root -g wheel", ""
    end

    # Build and install binary
    cd "sources" do
      mv "../sleepwatcher.8", "."
      system "make", "install", "PREFIX=#{prefix}"
    end
  end

  service do
    run [opt_sbin/"sleepwatcher", "-V", "-s", "#{Dir.home}/.sleep", "-w", "#{Dir.home}/.wakeup"]
    run_type :immediate
    keep_alive true
  end

  def caveats
    <<~EOS
      For SleepWatcher to work, you will need to write sleep and
      wakeup scripts, located here when using brew services:

        ~/.sleep
        ~/.wakeup
    EOS
  end
end
