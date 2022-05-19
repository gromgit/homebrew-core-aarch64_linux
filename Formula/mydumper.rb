class Mydumper < Formula
  desc "How MySQL DBA & support engineer would imagine 'mysqldump' ;-)"
  homepage "https://launchpad.net/mydumper"
  url "https://github.com/mydumper/mydumper/archive/v0.12.3-3.tar.gz"
  sha256 "8c7e3b44f5f4840188b1c32d50e82cdba6c8c735076930b02d1e33581e8447d9"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "34456dc63582bc6b1e8ef67449b655ac2d3123c581bd122fed5877cca9259c3e"
    sha256 cellar: :any,                 arm64_big_sur:  "1103f55c7d4074bfc8641b83a00b86ae0978ff1851bba2769aaef6173df750ea"
    sha256 cellar: :any,                 monterey:       "f7455b5cf3f953bed7eb0e1d994da5694a51ed80ed082f54e5e8c46e843d4246"
    sha256 cellar: :any,                 big_sur:        "6086bae7941f0b31b8315846c32f4d429246a2f748bcfe6eae770fc87ef265c0"
    sha256 cellar: :any,                 catalina:       "3be74acf157ae90396e74b63b8e3e8bcdf40940c2e52e9b279fbb1b7e5b111a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83c91cdf8b26d42788dfc150e03ca1090dd0506e80bb7a6b1c92bda98b68c2ed"
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
