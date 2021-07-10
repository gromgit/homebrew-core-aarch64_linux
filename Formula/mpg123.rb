class Mpg123 < Formula
  desc "MP3 player for Linux and UNIX"
  homepage "https://www.mpg123.de/"
  url "https://www.mpg123.de/download/mpg123-1.28.1.tar.bz2"
  mirror "https://downloads.sourceforge.net/project/mpg123/mpg123/1.28.1/mpg123-1.28.1.tar.bz2"
  sha256 "85d0b34e14b2d8b35dda7224b2452a7e9e7a3c8eddda595188a5122d0787b9aa"
  license "LGPL-2.1-only"

  livecheck do
    url "https://www.mpg123.de/download/"
    regex(/href=.*?mpg123[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "19ab71d0f5b0445b06256f129b971464071504d00da53031653721449e831f3f"
    sha256 big_sur:       "9e64bf29f8b4ae1cbd7f66c26802f0b358cf1dce6562c9905c036f9b1138d483"
    sha256 catalina:      "3e03a2915dad7b439afe28a3c37a9bf32ed5f0eabaa56d4ceb1ef9929a0262b8"
    sha256 mojave:        "84227846875d35bcbeba9980a90b2086c6d929f503986458cd98b5bf37723c05"
    sha256 x86_64_linux:  "cfdde128c6c9bb0a3471c11fc936853a6bcc1b90d9186e011072b6e00df20121"
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-module-suffix=.so
    ]

    on_macos do
      args << "--with-default-audio=coreaudio"
    end

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
