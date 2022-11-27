class Sysstat < Formula
  desc "Performance monitoring tools for Linux"
  homepage "https://github.com/sysstat/sysstat"
  url "https://github.com/sysstat/sysstat/archive/v12.6.0.tar.gz"
  sha256 "ffbcf991446a4fc67877340696dae28d71087d0d5e1acd3f46ca9cab15286dc7"
  license "GPL-2.0-or-later"
  head "https://github.com/sysstat/sysstat.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/sysstat"
    sha256 aarch64_linux: "8e8cf17ea4aee56f8854e613c3a2dd0cd7db9b152e4e320d4bf243ae58d3c8e0"
  end

  depends_on :linux

  def install
    system "./configure",
           "--disable-file-attr", # Fix install: cannot change ownership
           "--prefix=#{prefix}",
           "conf_dir=#{etc}/sysconfig",
           "sa_dir=#{var}/log/sa"
    system "make", "install"
  end

  test do
    assert_match("PID", shell_output("#{bin}/pidstat"))
    assert_match("avg-cpu", shell_output("#{bin}/iostat"))
  end
end
