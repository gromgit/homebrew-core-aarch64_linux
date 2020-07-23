class Re2c < Formula
  desc "Generate C-based recognizers from regular expressions"
  homepage "https://re2c.org"
  url "https://github.com/skvadrik/re2c/releases/download/2.0/re2c-2.0.tar.xz"
  sha256 "89a9d7ee14be10e3779ea7b2c8ea4a964afce6e76b8dbcd5479940681db46d20"

  bottle do
    sha256 "1f5cba0326bd4e86224cbbfea090b9b492da4d82b680ace1f516a6818b133c3e" => :catalina
    sha256 "56db2c3832a9321e5edea069ab3bee2121ac3c1c347fd3a7451497405243f065" => :mojave
    sha256 "1d1a64d03a9307a2ec03d4eb9b3e378c604a3c2bb713fa7869199bfdd291e0ce" => :high_sierra
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      unsigned int stou (const char * s)
      {
      #   define YYCTYPE char
          const YYCTYPE * YYCURSOR = s;
          unsigned int result = 0;

          for (;;)
          {
              /*!re2c
                  re2c:yyfill:enable = 0;

                  "\x00" { return result; }
                  [0-9]  { result = result * 10 + c; continue; }
              */
          }
      }
    EOS
    system bin/"re2c", "-is", testpath/"test.c"
  end
end
