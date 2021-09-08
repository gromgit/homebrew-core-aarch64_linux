class Mpg123 < Formula
  desc "MP3 player for Linux and UNIX"
  homepage "https://www.mpg123.de/"
  url "https://www.mpg123.de/download/mpg123-1.29.0.tar.bz2"
  mirror "https://downloads.sourceforge.net/project/mpg123/mpg123/1.29.0/mpg123-1.29.0.tar.bz2"
  sha256 "135e0172dfb6c7937a81f1188c27f9a47b0a337f7637680039ff3ee5fea3ce7d"
  license "LGPL-2.1-only"

  livecheck do
    url "https://www.mpg123.de/download/"
    regex(/href=.*?mpg123[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "9da7a8249c0b232c766cf1efab8e956a62a7d3e84889c4f94b7571918246476f"
    sha256 big_sur:       "2d7805fe21b9178ca7a4df40fb05b7b01f22b95be6b5cdc1a94c014f1d9aa50d"
    sha256 catalina:      "6fd71cfdf237aa77246851ef9401d10fe91f9e13ef7817c7e66d73c86b4f745d"
    sha256 mojave:        "281d8863a9b1af6d2e9024b8ebc7041206ed3f3a84e5469ec9a9feec1a3b92b0"
    sha256 x86_64_linux:  "59a245a3fbf56ea367ce412a04d804b809699b3266b0010da393451e8f6f4b7f"
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-module-suffix=.so
    ]

    args << "--with-default-audio=coreaudio" if OS.mac?

    args << if Hardware::CPU.arm?
      "--with-cpu=aarch64"
    else
      "--with-cpu=x86-64"
    end

    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"mpg123", "--test", test_fixtures("test.mp3")
  end
end
