class Mpack < Formula
  desc "MIME mail packing and unpacking"
  homepage "https://web.archive.org/web/20190220145801/ftp.andrew.cmu.edu/pub/mpack/"
  url "https://ftp.gwdg.de/pub/misc/mpack/mpack-1.6.tar.gz"
  mirror "https://fossies.org/linux/misc/old/mpack-1.6.tar.gz"
  sha256 "274108bb3a39982a4efc14fb3a65298e66c8e71367c3dabf49338162d207a94c"
  license "BSD-3-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/mpack"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "f5de4d38a70a02aaf4fa6be1762ebf84cb47f4f9e64f2c4aeb31e2049ef56a1b"
  end

  # Fix missing return value; clang refuses to compile otherwise
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/1ad38a9c/mpack/uudecode.c.patch"
    sha256 "52ad1592ee4b137cde6ddb3c26e3541fa0dcea55c53ae8b37546cd566c897a43"
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end
end
