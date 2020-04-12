class LibjsonRpcCpp < Formula
  desc "C++ framework for json-rpc"
  homepage "https://github.com/cinemast/libjson-rpc-cpp"
  url "https://github.com/cinemast/libjson-rpc-cpp/archive/v1.3.0.tar.gz"
  sha256 "cf132ad9697b034f22ff37d12a1f1c6f2647ec2236701de5e76f6036ab664156"
  head "https://github.com/cinemast/libjson-rpc-cpp.git"

  bottle do
    cellar :any
    sha256 "f4aef6279f5c511ca7fae59ef1546dad08f4520e332649581fce18e1d94395e5" => :catalina
    sha256 "7b854658a9794f7f042ab6e398a23c387fb704773f50d930040cddc536c05359" => :mojave
    sha256 "ad7ca67a02fd0aa8c7b62503a2ad05f5cce5afc67c6bb8b9d306f8b3e39776a6" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "argtable"
  depends_on "hiredis"
  depends_on "jsoncpp"
  depends_on "libmicrohttpd"

  uses_from_macos "curl"

  def install
    system "cmake", ".", *std_cmake_args, "-DCOMPILE_EXAMPLES=OFF", "-DCOMPILE_TESTS=OFF"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/jsonrpcstub", "-h"
  end
end
