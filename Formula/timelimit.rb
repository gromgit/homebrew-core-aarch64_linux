class Timelimit < Formula
  desc "Limit a process's absolute execution time"
  homepage "https://devel.ringlet.net/sysutils/timelimit/"
  url "https://devel.ringlet.net/files/sys/timelimit/timelimit-1.9.2.tar.gz"
  sha256 "320a72770288b2deeb9abbd343f9c27afcb6190bb128ad2a1e1ee2a03a796d45"
  license "BSD-2-Clause"

  livecheck do
    url :homepage
    regex(/latest release is .*?timelimit[._-]v?(\d+(?:\.\d+)+)</i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/timelimit"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "b68d64a15b162f6c29b18408cf6fd92051b44a7a8800669a6678f822057bcb1c"
  end

  def install
    # don't install for specific users
    inreplace "Makefile", "-o ${BINOWN} -g ${BINGRP}", ""
    inreplace "Makefile", "-o ${SHAREOWN} -g ${SHAREGRP}", ""

    args = %W[LOCALBASE=#{prefix} MANDIR=#{man}/man]

    check_args = args + ["check"]
    install_args = args + ["install"]

    system "make", *check_args
    system "make", *install_args
  end

  test do
    assert_match "timelimit: sending warning signal 15",
      shell_output("#{bin}/timelimit -p -t 1 sleep 5 2>&1", 143).chomp
  end
end
