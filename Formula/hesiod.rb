class Hesiod < Formula
  desc "Library for the simple string lookup service built on top of DNS"
  homepage "https://github.com/achernya/hesiod"
  url "https://github.com/achernya/hesiod/archive/hesiod-3.2.1.tar.gz"
  sha256 "813ccb091ad15d516a323bb8c7693597eec2ef616f36b73a8db78ff0b856ad63"
  license "BSD-2-Clause"
  revision 1

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/hesiod"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "34b59f37ef6745578efaed1064f76723a41ba26aed6d09047158ce996010a573"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "libidn"

  def install
    system "autoreconf", "-fvi"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/hesinfo", "sipbtest", "passwd"
    system "#{bin}/hesinfo", "sipbtest", "filsys"
  end
end
