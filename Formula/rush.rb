class Rush < Formula
  desc "GNU's Restricted User SHell"
  homepage "https://www.gnu.org/software/rush/"
  url "https://ftp.gnu.org/gnu/rush/rush-2.3.tar.xz"
  mirror "https://ftpmirror.gnu.org/rush/rush-2.3.tar.xz"
  sha256 "8cae258247cd2623e856ea5e2c62cd7f09e9e3e043e6fc63bbd1abec3d3fdd93"
  license "GPL-3.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/rush"
    sha256 aarch64_linux: "ec29ac1432e0ee7e738e8f1b351ad04b278be4bbfaa055e96a7857eb0bd5dabd"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{sbin}/rush", "-h"
  end
end
