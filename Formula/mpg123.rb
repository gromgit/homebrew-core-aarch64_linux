class Mpg123 < Formula
  desc "MP3 player for Linux and UNIX"
  homepage "https://www.mpg123.de/"
  url "https://downloads.sourceforge.net/project/mpg123/mpg123/1.26.1/mpg123-1.26.1.tar.bz2"
  sha256 "74d6629ab7f3dd9a588b0931528ba7ecfa989a2cad6bf53ffeef9de31b0fe032"

  bottle do
    sha256 "231bff62192a6c109c7eeafd4deb90b967197f0656a5aa6ff23360540b2ea3e2" => :catalina
    sha256 "853131e5b67225d5018b5574c9073dafee53d7fd8b326f164bad02b835ceee92" => :mojave
    sha256 "fc7974c5e52d1c85e0345e359371fc7b1b2b102e2b2b4b4107a5a761ce06c5f4" => :high_sierra
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
