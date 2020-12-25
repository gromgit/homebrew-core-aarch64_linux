class Kcgi < Formula
  desc "Minimal CGI and FastCGI library for C/C++"
  homepage "https://kristaps.bsd.lv/kcgi"
  url "https://kristaps.bsd.lv/kcgi/snapshots/kcgi-0.12.2.tgz"
  sha256 "59e9219ae439f0c4fbffe6584014715c2fc206b8cd00de7aa8d062ddb52c2a0e"
  license "ISC"

  bottle do
    cellar :any_skip_relocation
    sha256 "db56ea0e40697618474f90af5b3f354043027b837e94464650a81d3813cde3d9" => :big_sur
    sha256 "6c8f9cb34365dd0fae747d312badca68cb42bfcdddc1ab43e652b40bc01161d6" => :arm64_big_sur
    sha256 "a3190c30830f6667c7f6df30047610e12845835f3d16c647b3c223e7ec8033db" => :catalina
    sha256 "096b70bd684486a61c8c393aea6596268701807e27b41da94c0e5e996bfc7b3c" => :mojave
  end

  depends_on "bmake" => :build

  def install
    system "./configure", "MANDIR=#{man}",
                          "PREFIX=#{prefix}"
    system "bmake"
    system "bmake", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <sys/types.h>
      #include <stdarg.h>
      #include <stddef.h>
      #include <stdint.h>
      #include <kcgi.h>

      int
      main(void)
      {
        struct kreq r;
        const char *pages = "";

        khttp_parse(&r, NULL, 0, &pages, 1, 0);
        return 0;
      }
    EOS
    flags = %W[
      -L#{lib}
      -lkcgi
      -lz
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
