class Calc < Formula
  desc "Arbitrary precision calculator"
  homepage "http://www.isthe.com/chongo/tech/comp/calc/"
  url "https://downloads.sourceforge.net/project/calc/calc/2.14.0.13/calc-2.14.0.13.tar.bz2"
  sha256 "9da3418ac99a5a7ccb8e5532e3d473f4e7e485470575b9d6c6cf75ee88314e39"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_monterey: "1b85719255e54cab34f03f49ce13bf60c411ff2906fc656c4b01be3da9accad8"
    sha256 arm64_big_sur:  "27fe2c067679806edd3a6a2befd438d2074b3d80d8f88641e7767edd08b197e2"
    sha256 monterey:       "5f1da1bae1d178a6c84d3cb6d8e3f99c16fb1ace3fa4cce6bbcb23a1931f7a8e"
    sha256 big_sur:        "f9d9cf3596d31c19d939fcb37fcd4bbd7f5d4c91960a6db21a8517ee8660c25b"
    sha256 catalina:       "87f7b121bb153b15171ef29f1a848c9f548b19307382014b58230c6f7c00c67d"
    sha256 x86_64_linux:   "00b6c48fd779740a875250f822f09985cb2738998313f399d43baeefe68826c8"
  end

  depends_on "readline"

  on_linux do
    depends_on "util-linux" # for `col`
  end

  def install
    ENV.deparallelize

    ENV["EXTRA_CFLAGS"] = ENV.cflags
    ENV["EXTRA_LDFLAGS"] = ENV.ldflags

    args = [
      "BINDIR=#{bin}",
      "LIBDIR=#{lib}",
      "MANDIR=#{man1}",
      "CALC_INCDIR=#{include}/calc",
      "CALC_SHAREDIR=#{pkgshare}",
      "USE_READLINE=-DUSE_READLINE",
      "READLINE_LIB=-L#{Formula["readline"].opt_lib} -lreadline",
      "READLINE_EXTRAS=-lhistory -lncurses",
    ]
    args << "INCDIR=#{MacOS.sdk_path}/usr/include" if OS.mac?
    system "make", "install", *args

    libexec.install "#{bin}/cscript"
  end

  test do
    assert_equal "11", shell_output("#{bin}/calc 0xA + 1").strip
  end
end
