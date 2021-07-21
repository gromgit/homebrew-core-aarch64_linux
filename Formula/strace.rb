class Strace < Formula
  desc "Diagnostic, instructional, and debugging tool for the Linux kernel"
  homepage "https://strace.io/"
  url "https://github.com/strace/strace/releases/download/v5.13/strace-5.13.tar.xz"
  sha256 "5acc34888b9d510ad6ac915d4a8df08f51cf1ae920ea24649f6a4bb984d0b656"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ba1017ec6fd537dd5575312ec8ef777bd1293dc710efd1edaaa40bb1bd0084ea"
  end

  head do
    url "https://github.com/strace/strace.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on :linux
  depends_on "linux-headers@4.4"

  def install
    system "./bootstrap" if build.head?
    system "./configure",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}",
      "--enable-mpers=no" # FIX: configure: error: Cannot enable m32 personality support
    system "make", "install"
  end

  test do
    out = `"strace" "true" 2>&1` # strace the true command, redirect stderr to output
    assert_match "execve(", out
    assert_match "+++ exited with 0 +++", out
  end
end
