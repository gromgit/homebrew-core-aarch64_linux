class Mydumper < Formula
  desc "How MySQL DBA & support engineer would imagine 'mysqldump' ;-)"
  homepage "https://launchpad.net/mydumper"
  url "https://github.com/maxbube/mydumper/archive/v0.9.5.tar.gz"
  sha256 "544d434b13ec192976d596d9a7977f46b330f5ae3370f066dbe680c1a4697eb6"
  license "GPL-3.0-or-later"

  bottle do
    cellar :any
    sha256 "157bb28e44f0033093c6dc1e46ad6f72e72fb0ae39c9d480e4cff4d90b0a4384" => :catalina
    sha256 "d4a3a359cd266b24313e64204a8c99d8c1bfe0ec71fece2a31b8551bbb904eaa" => :mojave
    sha256 "2f3f2f488038ee040fe619c6f3c35efc414c97a18bfb04885a245528645f8ade" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "glib"
  depends_on "mysql-client"
  depends_on "openssl@1.1"
  depends_on "pcre"

  uses_from_macos "zlib"

  # This patch allows cmake to find .dylib shared libs in macOS. A bug report has
  # been filed upstream here: https://bugs.launchpad.net/mydumper/+bug/1517966
  # It also ignores .a libs because of an issue with glib's static libraries now
  # being included by default in homebrew.
  #
  # Although we override the mysql library location this patch is still required
  # because the setting of ${CMAKE_FIND_LIBRARY_SUFFIXES} affects other probes as well.
  patch :p0, :DATA

  def install
    system "cmake", ".", *std_cmake_args,
           # Override location of mysql-client:
           "-DMYSQL_CONFIG_PREFER_PATH=#{Formula["mysql-client"].opt_bin}",
           "-DMYSQL_LIBRARIES=#{Formula["mysql-client"].opt_lib}/libmysqlclient.dylib",
           # find_package(ZLIB) has troube on Big Sur since physical libz.dylib
           # doesn't exist on the filesystem.  Instead provide details ourselves:
           "-DCMAKE_DISABLE_FIND_PACKAGE_ZLIB=1", "-DZLIB_INCLUDE_DIRS=/usr/include", "-DZLIB_LIBRARIES=-lz"
    system "make", "install"
  end

  test do
    system bin/"mydumper", "--help"
  end
end

__END__
--- cmake/modules/FindMySQL.cmake	2015-09-16 16:11:34.000000000 -0400
+++ cmake/modules/FindMySQL.cmake	2015-09-16 16:10:56.000000000 -0400
@@ -84,7 +84,7 @@
 )

 set(TMP_MYSQL_LIBRARIES "")
-set(CMAKE_FIND_LIBRARY_SUFFIXES .so .a .lib .so.1)
+set(CMAKE_FIND_LIBRARY_SUFFIXES .so .lib .dylib .so.1)
 foreach(MY_LIB ${MYSQL_ADD_LIBRARIES})
     find_library("MYSQL_LIBRARIES_${MY_LIB}" NAMES ${MY_LIB}
         HINTS
