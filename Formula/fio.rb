class Fio < Formula
  desc "I/O benchmark and stress test"
  homepage "https://github.com/axboe/fio"
  url "https://github.com/axboe/fio/archive/fio-3.17.tar.gz"
  sha256 "d0c3bfe502f5c70e68fb478c537dc7c6539aed8bf0f898d84e6223e61fd2c65f"

  bottle do
    cellar :any_skip_relocation
    sha256 "992d93124d0f3312cff47e4a11eabd74dec486042881a0a314bb51f596d5a9af" => :catalina
    sha256 "6d184581dc68669bc1fcf2b6436d5d856bf50bcdf95b6a058467ec6e2dfd61a2" => :mojave
    sha256 "9d1f05f9bc6a04d81a88c05284344250e21446679243d5c9fccfcd4d51f85002" => :high_sierra
    sha256 "e41a6a72db927e9952d7025f1a64d8b5678a3f1d283570207110c1ddd766d467" => :sierra
  end

  def install
    system "./configure"
    # fio's CFLAGS passes vital stuff around, and crushing it will break the build
    system "make", "prefix=#{prefix}",
                   "mandir=#{man}",
                   "sharedir=#{share}",
                   "CC=#{ENV.cc}",
                   "V=true", # get normal verbose output from fio's makefile
                   "install"
  end

  test do
    system "#{bin}/fio", "--parse-only"
  end
end
