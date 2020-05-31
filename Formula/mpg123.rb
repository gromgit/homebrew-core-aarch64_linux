class Mpg123 < Formula
  desc "MP3 player for Linux and UNIX"
  homepage "https://www.mpg123.de/"
  url "https://downloads.sourceforge.net/project/mpg123/mpg123/1.26.1/mpg123-1.26.1.tar.bz2"
  sha256 "74d6629ab7f3dd9a588b0931528ba7ecfa989a2cad6bf53ffeef9de31b0fe032"

  bottle do
    sha256 "b533cb51989dc62bdfab0a132d677a320eb28441b9a3e17719539dafac8cc626" => :catalina
    sha256 "4f489969bb034741f240b3ff1d953ff125b7cc16114b66ca98afc62317a500e7" => :mojave
    sha256 "518142bd7c08441d055bcefec0bb574ad1494c12f4f1178aa9006ac01f25bc5e" => :high_sierra
  end

  def install
    # Work around Xcode 11 clang bug
    ENV.append_to_cflags "-fno-stack-check" if DevelopmentTools.clang_build_version >= 1010

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-default-audio=coreaudio
      --with-module-suffix=.so
      --with-cpu=x86-64
    ]
    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"mpg123", "--test", test_fixtures("test.mp3")
  end
end
