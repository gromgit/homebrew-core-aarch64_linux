class Mydumper < Formula
  desc "How MySQL DBA & support engineer would imagine 'mysqldump' ;-)"
  homepage "https://launchpad.net/mydumper"
  url "https://github.com/mydumper/mydumper/archive/v0.12.7-3.tar.gz"
  sha256 "28701956a2d6793290592cab36eb9ca6d5764a62845203fdfde4549c7acaa2f9"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+(-\d+)?)["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7c6f565a8de02caa5421c28c844fb61ffb42c7241082bd8532b961e42a00a228"
    sha256 cellar: :any,                 arm64_big_sur:  "c0479febbf7b90145c28559885a772086ea1aae48d4d3334f1b2489b352325a7"
    sha256 cellar: :any,                 monterey:       "dd097ff298de20b0f50221fa32463608be153e03b9656f1989c78ecd5fdf2d40"
    sha256 cellar: :any,                 big_sur:        "991d6124ee86f835abdaa0ceb6d24b51a9216870f77064faccab334c1c4468c1"
    sha256 cellar: :any,                 catalina:       "95cb5ddc27e5b7d7f4e6d22673b26589b572d88cd608ea1aa2f64201b4e8641f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84933d5939b40e597150d298ffa6abfa249e214916bb7fa5ced96532c3953b6d"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "glib"
  depends_on "mysql-client"
  depends_on "openssl@1.1"
  depends_on "pcre"

  uses_from_macos "zlib"

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
