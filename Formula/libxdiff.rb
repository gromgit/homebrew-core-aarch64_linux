class Libxdiff < Formula
  desc "Implements diff functions for binary and text files"
  homepage "http://www.xmailserver.org/xdiff-lib.html"
  url "http://www.xmailserver.org/libxdiff-0.23.tar.gz"
  sha256 "e9af96174e83c02b13d452a4827bdf47cb579eafd580953a8cd2c98900309124"
  license "LGPL-2.1"

  livecheck do
    url :homepage
    regex(/href=.*?libxdiff[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/libxdiff"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "de8705b994b8270164a272a30b8bea52f43eb81822df6a886ad6250af8800d11"
  end

  unless OS.linux? && Hardware::CPU.intel?
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "autoreconf", "--force", "--verbose", "--install" unless OS.linux? && Hardware::CPU.intel?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end
end
