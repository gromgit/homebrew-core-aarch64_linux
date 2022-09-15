class ClickhouseOdbc < Formula
  desc "Official ODBC driver implementation for accessing ClickHouse as a data source"
  homepage "https://github.com/ClickHouse/clickhouse-odbc#readme"
  url "https://github.com/ClickHouse/clickhouse-odbc.git",
      tag:      "v1.1.10.20210822",
      revision: "c7aaff6860e448acee523f5f7d3ee97862fd07d2"
  license "Apache-2.0"
  revision 2
  head "https://github.com/ClickHouse/clickhouse-odbc.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "672e479aa4cccebdf6361e42bd578faae5c9a374ded20d7f73c2b313d512fed4"
    sha256 cellar: :any,                 arm64_big_sur:  "b0db10491fb981f97a39d3996f96a93d581810345ff8f911374adfc22bd099cc"
    sha256 cellar: :any,                 monterey:       "2ec9b05c9f11cf5de3e3f6e35b4bf3864f7b04d3dc5044a31d0df55affac2ea6"
    sha256 cellar: :any,                 big_sur:        "922a347803f8a65bbd0ed3a159a1d2ac5522a281b3b7d174cbb03a0f9589e388"
    sha256 cellar: :any,                 catalina:       "d3ea7bcd2951037214fd4b91a8af8c9bbc05758f42bdcacfd8721fb6407171f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f07a7588bb547c0016fb80ffb7a1a30a52273f9942b8c0183beed47a0096eb45"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "icu4c"
  depends_on "openssl@1.1"

  on_macos do
    depends_on "libiodbc"
  end

  on_linux do
    depends_on "unixodbc"
  end

  fails_with gcc: "5"
  fails_with gcc: "6"

  def install
    cmake_args = std_cmake_args.dup

    cmake_args << "-DOPENSSL_ROOT_DIR=#{Formula["openssl@1.1"].opt_prefix}"
    cmake_args << "-DICU_ROOT=#{Formula["icu4c"].opt_prefix}"

    if OS.mac?
      cmake_args << "-DODBC_PROVIDER=iODBC"
      cmake_args << "-DODBC_DIR=#{Formula["libiodbc"].opt_prefix}"
    elsif OS.linux?
      cmake_args << "-DODBC_PROVIDER=UnixODBC"
      cmake_args << "-DODBC_DIR=#{Formula["unixodbc"].opt_prefix}"
    end

    system "cmake", "-S", ".", "-B", "build", *cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"my.odbcinst.ini").write <<~EOS
      [ODBC Drivers]
      ClickHouse ODBC Test Driver A = Installed
      ClickHouse ODBC Test Driver W = Installed

      [ClickHouse ODBC Test Driver A]
      Description = ODBC Driver for ClickHouse (ANSI)
      Driver      = #{lib/shared_library("libclickhouseodbc")}
      Setup       = #{lib/shared_library("libclickhouseodbc")}
      UsageCount  = 1

      [ClickHouse ODBC Test Driver W]
      Description = ODBC Driver for ClickHouse (Unicode)
      Driver      = #{lib/shared_library("libclickhouseodbcw")}
      Setup       = #{lib/shared_library("libclickhouseodbcw")}
      UsageCount  = 1
    EOS

    (testpath/"my.odbc.ini").write <<~EOS
      [ODBC Data Sources]
      ClickHouse ODBC Test DSN A = ClickHouse ODBC Test Driver A
      ClickHouse ODBC Test DSN W = ClickHouse ODBC Test Driver W

      [ClickHouse ODBC Test DSN A]
      Driver      = ClickHouse ODBC Test Driver A
      Description = DSN for ClickHouse ODBC Test Driver (ANSI)
      Url         = https://default:password@example.com:8443/query?database=default

      [ClickHouse ODBC Test DSN W]
      Driver      = ClickHouse ODBC Test Driver W
      Description = DSN for ClickHouse ODBC Test Driver (Unicode)
      Url         = https://default:password@example.com:8443/query?database=default
    EOS

    ENV["ODBCSYSINI"] = testpath
    ENV["ODBCINSTINI"] = "my.odbcinst.ini"
    ENV["ODBCINI"] = "#{ENV["ODBCSYSINI"]}/my.odbc.ini"

    if OS.mac?
      ENV["ODBCINSTINI"] = "#{ENV["ODBCSYSINI"]}/#{ENV["ODBCINSTINI"]}"

      assert_match "SQL>",
        pipe_output("#{Formula["libiodbc"].bin}/iodbctest 'DSN=ClickHouse ODBC Test DSN A'", "exit\n")

      assert_match "SQL>",
        pipe_output("#{Formula["libiodbc"].bin}/iodbctestw 'DSN=ClickHouse ODBC Test DSN W'", "exit\n")
    elsif OS.linux?
      assert_match "Connected!",
        pipe_output("#{Formula["unixodbc"].bin}/isql 'ClickHouse ODBC Test DSN A'", "quit\n")

      assert_match "Connected!",
        pipe_output("#{Formula["unixodbc"].bin}/iusql 'ClickHouse ODBC Test DSN W'", "quit\n")
    end
  end
end
