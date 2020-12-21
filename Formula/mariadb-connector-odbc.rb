class MariadbConnectorOdbc < Formula
  desc "Database driver using the industry standard ODBC API"
  homepage "https://downloads.mariadb.org/connector-odbc/"
  url "https://downloads.mariadb.org/f/connector-odbc-3.1.11/mariadb-connector-odbc-3.1.11-ga-src.tar.gz"
  sha256 "d81a35cd9c9d2e1e732b7bd9ee704eb83775ed74bcc38d6cd5d367a3fc525a34"
  license "LGPL-2.1-or-later"

  livecheck do
    url :homepage
    regex(/Download (\d+(?:\.\d+)+) Stable Now!/i)
  end

  bottle do
    sha256 "339b4c5fa7121936bd5ed68e5d6c507400e43445bc46b63f6cea6212e047c66f" => :catalina
    sha256 "4ba2a2852289ab5843bba747e84188d0c663d39129be4bb57ef23307ffc93261" => :mojave
    sha256 "49f91ee3450c6650885b90efa9c07ca5d23f72fdd8a37387302cdf5c0ad548a9" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "mariadb-connector-c"
  depends_on "openssl@1.1"
  depends_on "unixodbc"

  def install
    ENV.append_to_cflags "-I#{Formula["mariadb-connector-c"].opt_include}/mariadb"
    ENV.append "LDFLAGS", "-L#{Formula["mariadb-connector-c"].opt_lib}/mariadb"
    system "cmake", ".", "-DMARIADB_LINK_DYNAMIC=1",
                         "-DWITH_SSL=OPENSSL",
                         "-DOPENSSL_ROOT_DIR=#{Formula["openssl@1.1"].opt_prefix}",
                         "-DWITH_IODBC=0",
                         # Workaround 3.1.11 issues finding system's built-in -liconv
                         # See https://jira.mariadb.org/browse/ODBC-299
                         "-DICONV_LIBRARIES=#{MacOS.sdk_path}/usr/lib/libiconv.tbd",
                         "-DICONV_INCLUDE_DIR=/usr/include",
                         *std_cmake_args

    # By default, the installer pkg is built - we don't want that.
    # maodbc limits the build to just the connector itself.
    # install/fast prevents an "all" build being invoked that a regular "install" would do.
    system "make", "maodbc"
    system "make", "install/fast"
  end

  test do
    output = shell_output("#{Formula["unixodbc"].opt_bin}/dltest #{lib}/mariadb/#{shared_library("libmaodbc")}")
    assert_equal "SUCCESS: Loaded #{lib}/mariadb/#{shared_library("libmaodbc")}", output.chomp
  end
end
