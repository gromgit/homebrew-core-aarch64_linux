class LibjsonRpcCpp < Formula
  desc "C++ framework for json-rpc"
  homepage "https://github.com/cinemast/libjson-rpc-cpp"
  url "https://github.com/cinemast/libjson-rpc-cpp/archive/v1.3.0.tar.gz"
  sha256 "cf132ad9697b034f22ff37d12a1f1c6f2647ec2236701de5e76f6036ab664156"
  license "MIT"
  revision 2
  head "https://github.com/cinemast/libjson-rpc-cpp.git"

  bottle do
    cellar :any
    sha256 "1187bd48b858e3f9c2cfb8909bd7ba0a75973179a2254b335dd208304a8b0e00" => :big_sur
    sha256 "00eaebee121524bd0c92f7e02090c503b0d7e5b8ba34ee0637d9598bac711e2c" => :arm64_big_sur
    sha256 "5f4124936a55b2fa598205b70d615137f1b5726f62f71e36b9d6a2f2dee8c127" => :catalina
    sha256 "02a2722ed816d843eb3eaf38dbd2634d8ee325bb4be95c94a35383a7ed5c6955" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "argtable"
  depends_on "hiredis"
  depends_on "jsoncpp"
  depends_on "libmicrohttpd"

  uses_from_macos "curl"

  # Fix for https://github.com/cinemast/libjson-rpc-cpp/issues/298
  patch do
    url "https://github.com/cinemast/libjson-rpc-cpp/commit/fa163678134aced775651558f91a006791e26ef8.patch?full_index=1"
    sha256 "80a8cdfa40aba3dc71fbab77b0137f7f03bb9c969b9845e68f83181b4d8550f6"
  end

  def install
    system "cmake", ".", *std_cmake_args, "-DCOMPILE_EXAMPLES=OFF", "-DCOMPILE_TESTS=OFF"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/jsonrpcstub", "-h"
  end
end
