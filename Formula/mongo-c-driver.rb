class MongoCDriver < Formula
  desc "C driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-c-driver"
  url "https://github.com/mongodb/mongo-c-driver/releases/download/1.18.0/mongo-c-driver-1.18.0.tar.gz"
  sha256 "db9bfc28355fe068c88b00974ca770a5449c7931b66f2895c9fbf2104d883992"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongo-c-driver.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "b32b43cfbdcf8a6886d549e062bfc05ebdebc561b380aa9a860efb4b5a6903cf"
    sha256 cellar: :any,                 big_sur:       "b6b2cce1b0e769f831a568fd288062ebff90a72af119977c705e555fbc7a93e8"
    sha256 cellar: :any,                 catalina:      "55cee809f56d9386cf6c3c31ce50e9a221448f462cee6b19e91b4b909ede935e"
    sha256 cellar: :any,                 mojave:        "1224bad595b44b5b36f5d482aec0b135b8c9789ae9d4797ceaa9bf6994bff7be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86607f8a41038ad1691652aa265f3062ac883891f937ce2cb474e2e617e600da"
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
