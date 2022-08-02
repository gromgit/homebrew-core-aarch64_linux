class MongoCDriver < Formula
  desc "C driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-c-driver"
  url "https://github.com/mongodb/mongo-c-driver/releases/download/1.22.1/mongo-c-driver-1.22.1.tar.gz"
  sha256 "762735344e848bb2f100154ed2f7b0f8c9b25e37eafb2b79b54bf99c15a7c318"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongo-c-driver.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "20d09916e7109e6b255946b212f99efada06ff00b11bff578c7594fa12e13fb3"
    sha256 cellar: :any,                 arm64_big_sur:  "b6f9a48b49d59a52ac7dfd12f823240fe5928bbe5ed7d385486d86ef144cb555"
    sha256 cellar: :any,                 monterey:       "edde69554f45cfa4be3813d02f6d62f97747fb9d11f4052e203c1ae3d31e297d"
    sha256 cellar: :any,                 big_sur:        "1dd353ef007719d826dcb26d17a16fbf01279bb6ee67a34d9c44358575183ec0"
    sha256 cellar: :any,                 catalina:       "fdbbed172df855ee08a6d8d579a5d99081cee9dd7d6b843b21637b39ef6b5cd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34acfb2a109e11595de3afcc7f4d1fce41ef41f47ab7808ba9cab2a4d7f49e61"
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
