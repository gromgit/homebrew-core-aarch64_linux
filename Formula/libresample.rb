class Libresample < Formula
  desc "Audio resampling C library"
  homepage "https://ccrma.stanford.edu/~jos/resample/Available_Software.html"
  url "https://deb.debian.org/debian/pool/main/libr/libresample/libresample_0.1.3.orig.tar.gz"
  sha256 "20222a84e3b4246c36b8a0b74834bb5674026ffdb8b9093a76aaf01560ad4815"
  license "LGPL-2.1"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/libresample"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "904f7490c47e635c88291f139cf8bc31303f100a49fcb5dbac2ccb951b479f33"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    lib.install "libresample.a"
    include.install "include/libresample.h"
  end
end
