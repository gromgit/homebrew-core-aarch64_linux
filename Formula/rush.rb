class Rush < Formula
  desc "GNU's Restricted User SHell"
  homepage "https://www.gnu.org/software/rush/"
  url "https://ftp.gnu.org/gnu/rush/rush-2.2.tar.xz"
  mirror "https://ftpmirror.gnu.org/rush/rush-2.2.tar.xz"
  sha256 "b1fb69dcd2b082cc5bca804307baeec4ed6da77f747df0066c7d1ad2c353797f"
  license "GPL-3.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/rush"
    sha256 aarch64_linux: "941ed0236caca0944d74bada7143d5ada0f8a8ea5c268515abee43dc81b412c1"
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
