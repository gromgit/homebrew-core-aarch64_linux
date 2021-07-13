class MongoCDriver < Formula
  desc "C driver for MongoDB"
  homepage "https://github.com/mongodb/mongo-c-driver"
  url "https://github.com/mongodb/mongo-c-driver/releases/download/1.18.0/mongo-c-driver-1.18.0.tar.gz"
  sha256 "db9bfc28355fe068c88b00974ca770a5449c7931b66f2895c9fbf2104d883992"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongo-c-driver.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "24d4d16c759eb53b614d596d4a1759f7166a463e3dbd9aecdf657c58fab04512"
    sha256 cellar: :any,                 big_sur:       "514427be599aea9adc6601f33cd242619c218a2cacf33a919fcdf230d283084a"
    sha256 cellar: :any,                 catalina:      "abeb0a6d8048c79288aac204342888a7e70883927d675ffcbbf474299a95847f"
    sha256 cellar: :any,                 mojave:        "d256dcb80336babd2201b8ac723e72b6a4131cba639b7f86879dddf9d741560f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9235b7a6e52eb423a2e402c132f1899691ac089c5acb5a55420f877a14545ba"
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
