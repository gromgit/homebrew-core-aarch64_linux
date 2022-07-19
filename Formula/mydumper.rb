class Mydumper < Formula
  desc "How MySQL DBA & support engineer would imagine 'mysqldump' ;-)"
  homepage "https://launchpad.net/mydumper"
  url "https://github.com/mydumper/mydumper/archive/v0.12.5-3.tar.gz"
  sha256 "2fc5af9643a27eaca0a2ab37ba11ccac4d82f20bd8a9c14c886961453aafdf24"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e47e5b2a18e71c0fe871a995ee5b046b63d6c813ec7374888d22e96848ec0a42"
    sha256 cellar: :any,                 arm64_big_sur:  "a09f2c280a35ee5d063fcd796ad687d6331f908a2903d4a6187d11f66ded8437"
    sha256 cellar: :any,                 monterey:       "cc6dc43f2fb41b89deec1356eaf74b63c50d763bbc6c6331d04a75827580d49d"
    sha256 cellar: :any,                 big_sur:        "697998297657008e729f550b2e76a5decec6fe6aa158c4e2a1829d97202d8ed6"
    sha256 cellar: :any,                 catalina:       "4e63d6cf3c3e34f78ce432f414fe71a90e794a74bf2a98aabad4d75548d5b525"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7832ad06b4d148ff74b88a00807abbbce04bb72cb620dfa33f1cf338598d5967"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "glib"
  depends_on "mysql-client"
  depends_on "openssl@1.1"
  depends_on "pcre"

  uses_from_macos "zlib"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    # Override location of mysql-client
    args = std_cmake_args + %W[
      -DMYSQL_CONFIG_PREFER_PATH=#{Formula["mysql-client"].opt_bin}
      -DMYSQL_LIBRARIES=#{Formula["mysql-client"].opt_lib/shared_library("libmysqlclient")}
    ]
    # find_package(ZLIB) has trouble on Big Sur since physical libz.dylib
    # doesn't exist on the filesystem.  Instead provide details ourselves:
    if OS.mac?
      args << "-DCMAKE_DISABLE_FIND_PACKAGE_ZLIB=1"
      args << "-DZLIB_INCLUDE_DIRS=/usr/include"
      args << "-DZLIB_LIBRARIES=-lz"
    end

    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    system bin/"mydumper", "--help"
  end
end
