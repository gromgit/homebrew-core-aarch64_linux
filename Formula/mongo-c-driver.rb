class MongoCDriver < Formula
  desc "C driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-c-driver"
  url "https://github.com/mongodb/mongo-c-driver/releases/download/1.23.0/mongo-c-driver-1.23.0.tar.gz"
  sha256 "2b91d6a9c1a80ec82c5643676e44f1a9edf3849c7f25d490e1b5587eb408ad93"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongo-c-driver.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a6d8f0341988a9c43f795af111f76e4e49bf1d2433ca6493508c7a3e3515f8c1"
    sha256 cellar: :any,                 arm64_big_sur:  "3a5f68cecd0473e91ef7ce8db11ab644c4d92f943b0cd10c1bbedb253bac4d9a"
    sha256 cellar: :any,                 monterey:       "a28850f7e36baa7b20a35b8e349a0b121faf33d7b0a04c0f725965c9807d07f2"
    sha256 cellar: :any,                 big_sur:        "cf5984e0dce3cf3dc3dd349e7a94fbf3859d62196891e096c3e922c2ef64e25c"
    sha256 cellar: :any,                 catalina:       "561be6bbb35f0f171a16efeae183a8874b101f20d3734d29bd9229aff29f4671"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87ce39774e29829888b2ac714b32e38adc4e44ca7c659178b3896c684d4b2ea4"
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
    cmake_args << "-DMONGOC_TEST_USE_CRYPT_SHARED=FALSE"
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
