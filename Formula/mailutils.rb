class Mailutils < Formula
  desc "Swiss Army knife of email handling"
  homepage "https://mailutils.org/"
  url "https://ftp.gnu.org/gnu/mailutils/mailutils-3.11.tar.gz"
  mirror "https://ftpmirror.gnu.org/mailutils/mailutils-3.11.tar.gz"
  sha256 "7e507b28270da2771eb18aaca1648ef637a668bfaa41b50990e775dcd6c6c4af"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "18e4b39e0d08513d683225d6bbf2b599415954e5d152d05755b3c7594e7867f1" => :big_sur
    sha256 "61960d03d4a4aa6bc67f18a54e45211786777d01290918e110aee0cfedcfb637" => :arm64_big_sur
    sha256 "843a30ab78bc59fa5a99a99ac7f45f09a2f145e4361e4cc877d1277fc44b41ed" => :catalina
    sha256 "ce6bcfccb0b14b3c571b41eddaef778f25285a02e4534b6d610e058025d82677" => :mojave
  end

  depends_on "gnutls"
  depends_on "gsasl"
  depends_on "libtool"
  depends_on "readline"

  def install
    system "./configure", "--disable-mh",
                          "--prefix=#{prefix}",
                          "--without-fribidi",
                          "--without-gdbm",
                          "--without-guile",
                          "--without-tokyocabinet"
    system "make", "PYTHON_LIBS=-undefined dynamic_lookup", "install"
  end

  test do
    system "#{bin}/movemail", "--version"
  end
end
