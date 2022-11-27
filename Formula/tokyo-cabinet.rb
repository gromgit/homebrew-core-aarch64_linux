class TokyoCabinet < Formula
  desc "Lightweight database library"
  homepage "https://dbmx.net/tokyocabinet/"
  url "https://dbmx.net/tokyocabinet/tokyocabinet-1.4.48.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/t/tokyocabinet/tokyocabinet_1.4.48.orig.tar.gz"
  sha256 "a003f47c39a91e22d76bc4fe68b9b3de0f38851b160bbb1ca07a4f6441de1f90"
  license "LGPL-2.1-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?tokyocabinet[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/tokyo-cabinet"
    sha256 aarch64_linux: "56ca319ba63a8b6dce714e0c3128bef13a0de834c9081d34b20cb1dfe7391e97"
  end

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
