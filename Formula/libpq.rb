class Libpq < Formula
  desc "Postgres C API library"
  homepage "https://www.postgresql.org/docs/12/libpq.html"
  url "https://ftp.postgresql.org/pub/source/v12.1/postgresql-12.1.tar.bz2"
  sha256 "a09bf3abbaf6763980d0f8acbb943b7629a8b20073de18d867aecdb7988483ed"

  bottle do
    sha256 "40e1dae7e45682dea663096349858936ce6b885ce25db523f27469e3f18febab" => :catalina
    sha256 "641895e3f770b0eaa23bb7669c6ab8a198d67d341237cd1da6751f3e22ed8549" => :mojave
    sha256 "f95a9ac7f46a6a1ad8c74e609c0ab2160591457ff8aa8785ea08792d90d4efb6" => :high_sierra
    sha256 "94894610fed9516c72b9ed8bade18869d6ff71cd6ab2a28db2ed604ace0a023e" => :sierra
  end

  keg_only "conflicts with postgres formula"

  depends_on "openssl@1.1"

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--with-openssl",
                          "--libdir=#{opt_lib}",
                          "--includedir=#{opt_include}"
    dirs = %W[
      libdir=#{lib}
      includedir=#{include}
      pkgincludedir=#{include}/postgresql
      includedir_server=#{include}/postgresql/server
      includedir_internal=#{include}/postgresql/internal
    ]
    system "make"
    system "make", "-C", "src/bin", "install", *dirs
    system "make", "-C", "src/include", "install", *dirs
    system "make", "-C", "src/interfaces", "install", *dirs
    system "make", "-C", "doc", "install", *dirs
  end

  test do
    (testpath/"libpq.c").write <<~EOS
      #include <stdlib.h>
      #include <stdio.h>
      #include <libpq-fe.h>

      int main()
      {
          const char *conninfo;
          PGconn     *conn;

          conninfo = "dbname = postgres";

          conn = PQconnectdb(conninfo);

          if (PQstatus(conn) != CONNECTION_OK) // This should always fail
          {
              printf("Connection to database attempted and failed");
              PQfinish(conn);
              exit(0);
          }

          return 0;
        }
    EOS
    system ENV.cc, "libpq.c", "-L#{lib}", "-I#{include}", "-lpq", "-o", "libpqtest"
    assert_equal "Connection to database attempted and failed", shell_output("./libpqtest")
  end
end
