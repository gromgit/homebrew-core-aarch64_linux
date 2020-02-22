class CstoreFdw < Formula
  desc "Columnar store for analytics with Postgres"
  homepage "https://github.com/citusdata/cstore_fdw"
  url "https://github.com/citusdata/cstore_fdw/archive/v1.7.0.tar.gz"
  sha256 "bd8a06654b483d27b48d8196cf6baac0c7828b431b49ac097923ac0c54a1c38c"

  bottle do
    cellar :any
    sha256 "d6b1fd16c930e9296175924104500bbb277780fa432a6c798ca08550038e5d67" => :catalina
    sha256 "da634eeeaef15ef6f5820a5d5b0c9fc9cb9267d575d3ec95a60f86d94112b9da" => :mojave
    sha256 "76c6867e57fdaf5be3b0841d833602c222280642255238a3fd65c7aa24c0e4a5" => :high_sierra
  end

  depends_on "postgresql"
  depends_on "protobuf-c"

  def install
    # workaround for https://github.com/Homebrew/homebrew/issues/49948
    system "make", "libpq=-L#{Formula["postgresql"].opt_lib} -lpq"

    # Use stage directory to prevent installing to pg_config-defined dirs,
    # which would not be within this package's Cellar.
    mkdir "stage"
    system "make", "install", "DESTDIR=#{buildpath}/stage"

    lib.install Dir["stage/**/lib/*"]
    (share/"postgresql/extension").install Dir["stage/**/share/postgresql/extension/*"]
  end

  test do
    pg_bin = Formula["postgresql"].opt_bin
    pg_port = "55561"
    system "#{pg_bin}/initdb", testpath/"test"
    pid = fork do
      exec("#{pg_bin}/postgres",
           "-D", testpath/"test",
           "-c", "shared_preload_libraries=cstore_fdw",
           "-p", pg_port)
    end

    begin
      sleep 2

      cmds = ["CREATE EXTENSION cstore_fdw;",
              "CREATE SERVER cstore_server FOREIGN data WRAPPER cstore_fdw;",
              "CREATE FOREIGN TABLE T(x int) SERVER cstore_server OPTIONS(compression 'pglz');",
              "INSERT INTO T(x) SELECT 42;"]

      system "#{pg_bin}/createdb", "-p", pg_port, "test"
      system "#{pg_bin}/psql", "-p", pg_port, "-d", "test", "--command", cmds[0]
      system "#{pg_bin}/psql", "-p", pg_port, "-d", "test", "--command", cmds[1]
      system "#{pg_bin}/psql", "-p", pg_port, "-d", "test", "--command", cmds[2]
      system "#{pg_bin}/psql", "-p", pg_port, "-d", "test", "--command", cmds[3]

      assert_equal "42", shell_output("#{pg_bin}/psql -p #{pg_port} -d test -AXtc" \
                                      "'SELECT x from T;'").strip
    ensure
      Process.kill 9, pid
      Process.wait pid
    end
  end
end
