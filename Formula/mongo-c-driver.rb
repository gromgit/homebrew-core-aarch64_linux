class MongoCDriver < Formula
  desc "C driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-c-driver"
  url "https://github.com/mongodb/mongo-c-driver/releases/download/1.17.6/mongo-c-driver-1.17.6.tar.gz"
  sha256 "8644deec7ae585e8d12566978f2017181e883f303a028b5b3ccb83c91248b150"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongo-c-driver.git"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_big_sur: "b10fae562660ecdb9bc8cba4188eb1a62eaef68e781d21cb1854a25949a4ad78"
    sha256 cellar: :any, big_sur:       "191fbb678fcdf1934626e694b66f8ba40589e4dcf20a2d3a9c11b5d458d434f4"
    sha256 cellar: :any, catalina:      "453676b8382d21cf0ab777b2e2e2e7e690045288f81861a82a9f4ca2ff4d51d8"
    sha256 cellar: :any, mojave:        "1e1bdeedea7a6c15fd096ff77c6291e5f48398dbcb6eb388528de8e80a79614d"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  def install
    cmake_args = std_cmake_args
    cmake_args << "-DBUILD_VERSION=1.18.0-pre" if build.head?
    cmake_args << "-DCMAKE_INSTALL_RPATH=#{rpath}"
    inreplace "src/libmongoc/src/mongoc/mongoc-config.h.in", "@MONGOC_CC@", ENV.cc
    system "cmake", ".", *cmake_args
    system "make", "install"
    (pkgshare/"libbson").install "src/libbson/examples"
    (pkgshare/"libmongoc").install "src/libmongoc/examples"
  end

  test do
    system ENV.cc, "-o", "test", pkgshare/"libbson/examples/json-to-bson.c",
      "-I#{include}/libbson-1.0", "-L#{lib}", "-lbson-1.0"
    (testpath/"test.json").write('{"name": "test"}')
    assert_match "\u0000test\u0000", shell_output("./test test.json")

    system ENV.cc, "-o", "test", pkgshare/"libmongoc/examples/mongoc-ping.c",
      "-I#{include}/libmongoc-1.0", "-I#{include}/libbson-1.0",
      "-L#{lib}", "-lmongoc-1.0", "-lbson-1.0"
    assert_match "No suitable servers", shell_output("./test mongodb://0.0.0.0 2>&1", 3)
  end
end
