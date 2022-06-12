class Kcgi < Formula
  desc "Minimal CGI and FastCGI library for C/C++"
  homepage "https://kristaps.bsd.lv/kcgi/"
  url "https://kristaps.bsd.lv/kcgi/snapshots/kcgi-0.13.0.tgz"
  sha256 "d886e5700f5ec72b00cb668e9f06b7b3906b6ccdc5bab4c89e436d4cc4c0c7a1"
  license "ISC"

  livecheck do
    url "https://kristaps.bsd.lv/kcgi/snapshots/"
    regex(/href=.*?kcgi[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/kcgi"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "a1d8856ff183ba638e8d8b09b9cd2df6602006c03d5dcdb3555c392c43ba7c2b"
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
