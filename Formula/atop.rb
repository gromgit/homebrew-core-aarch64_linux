class Atop < Formula
  desc "Advanced system and process monitor for Linux using process events"
  homepage "https://www.atoptool.nl"
  url "https://github.com/Atoptool/atop/archive/refs/tags/v2.7.1.tar.gz"
  sha256 "ce79220b7b1511ae462470a559109322616701845e47275f7449192d379fb843"
  license "GPL-2.0-or-later"
  head "https://github.com/Atoptool/atop.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/atop"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "a3c91b73cfed15bd73c1a5c6831895fdc301b03764a2e4e194ec0b9ef5a3c01e"
  end

  depends_on :linux
  depends_on "linux-headers@4.15"
  depends_on "ncurses"
  depends_on "zlib"

  def install
    if build.head?
      inreplace "version.h" do |s|
        s.sub!(/"$/, "-#{Utils.git_short_head}\"")
      end
    end
    # As this project does not use configrue, we have to configure manually:
    ENV["BINPATH"] = bin.to_s
    ENV["SBINPATH"] = bin.to_s
    ENV["MAN1PATH"] = man1.to_s
    ENV["MAN5PATH"] = man5.to_s
    ENV["MAN8PATH"] = man8.to_s
    ENV["DEFPATH"] = "prev"
    ENV["LOGPATH"] = "prev"
    # It would try to install some files suid, which is not good for users:
    inreplace "Makefile", "chmod", "true"
    # RPM and Debian packages do not use the Makefile for users, but it ensures we forget nothing:
    system "make", "-e", "genericinstall"
  end

  test do
    assert_match "Version:", shell_output("#{bin}/atop -V")
    system "#{bin}/atop", "1", "1"
    system "#{bin}/atop", "-w", "atop.raw", "1", "1"
    system "#{bin}/atop", "-r", "atop.raw", "-PCPU,DSK"
  end
end
