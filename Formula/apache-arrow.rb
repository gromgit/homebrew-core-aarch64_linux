class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-4.0.0/apache-arrow-4.0.0.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-4.0.0/apache-arrow-4.0.0.tar.gz"
  sha256 "4a31d0bf702e953bdbcda67af10762a33308281bd247fcbd152ee177419649ae"
  license "Apache-2.0"
  head "https://github.com/apache/arrow.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "64f82d9bdc476fe3cc6a201de3983cd3c1177ac6fd038918ea36b1771d297120"
    sha256 cellar: :any, big_sur:       "8261f65e35b902389be6a40ff3734cbec6afdfa06a5732292f75cc7e0b068f8a"
    sha256 cellar: :any, catalina:      "ad81da9f96a7a6d5efa5c0eea5403c47eaec53fe54d1cb8e922a3d0ff7ceeb00"
    sha256 cellar: :any, mojave:        "60c0e8f79baaa38228ba30bfae9ad6b98dc754633a949eda69d5a10fd61245ee"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "brotli"
  depends_on "glog"
  depends_on "grpc"
  depends_on "lz4"
  depends_on "numpy"
  depends_on "openssl@1.1"
  depends_on "protobuf"
  depends_on "python@3.9"
  depends_on "rapidjson"
  depends_on "re2"
  depends_on "snappy"
  depends_on "thrift"
  depends_on "zstd"

  def install
    # link against system libc++ instead of llvm provided libc++
    ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib
    args = %W[
      -DCMAKE_FIND_PACKAGE_PREFER_CONFIG=TRUE
      -DARROW_FLIGHT=ON
      -DARROW_GANDIVA=ON
      -DARROW_JEMALLOC=ON
      -DARROW_ORC=ON
      -DARROW_PARQUET=ON
      -DARROW_PLASMA=ON
      -DARROW_PROTOBUF_USE_SHARED=ON
      -DARROW_PYTHON=ON
      -DARROW_WITH_BZ2=ON
      -DARROW_WITH_ZLIB=ON
      -DARROW_WITH_ZSTD=ON
      -DARROW_WITH_LZ4=ON
      -DARROW_WITH_SNAPPY=ON
      -DARROW_WITH_BROTLI=ON
      -DARROW_INSTALL_NAME_RPATH=OFF
      -DPYTHON_EXECUTABLE=#{Formula["python@3.9"].bin/"python3"}
    ]

    args << "-DARROW_MIMALLOC=ON" unless Hardware::CPU.arm?

    mkdir "build" do
      system "cmake", "../cpp", *std_cmake_args, *args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "arrow/api.h"
      int main(void) {
        arrow::int64();
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++11", "-I#{include}", "-L#{lib}", "-larrow", "-o", "test"
    system "./test"
  end
end
