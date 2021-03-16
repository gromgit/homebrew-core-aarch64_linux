class Fio < Formula
  desc "I/O benchmark and stress test"
  homepage "https://github.com/axboe/fio"
  url "https://github.com/axboe/fio/archive/fio-3.26.tar.gz"
  sha256 "8bd6987fd9b8c2a75d3923661566ade50b99f61fa4352148975e65577ffa4024"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "92ab29de16f4c30e39280b99cba069ed03c948b98a2f929acdcab01c35f9cd16"
    sha256 cellar: :any_skip_relocation, big_sur:       "f1bdc63c280e34e214bc569480d317e957f93fe1d36f68c091f641f83d345b75"
    sha256 cellar: :any_skip_relocation, catalina:      "3c43bc09449260fe0ce84250b75c9c92dcd441f823542105260c684bf8331003"
    sha256 cellar: :any_skip_relocation, mojave:        "b1ac6ab2cac3b7833fdd336a5c5a1e811ec071f8b64edab9ac819ea87dc09635"
  end

  uses_from_macos "zlib"

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
