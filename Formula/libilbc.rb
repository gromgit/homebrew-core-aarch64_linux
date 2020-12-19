class Libilbc < Formula
  desc "Packaged version of iLBC codec from the WebRTC project"
  homepage "https://github.com/TimothyGu/libilbc"
  url "https://github.com/TimothyGu/libilbc/releases/download/v3.0.2/libilbc-3.0.2.tar.gz"
  sha256 "e82cbc41c8c84c0828af869a9c6bbb62e06dece0d17d069c8b9db95082f0a4ce"
  license "BSD-3-Clause"

  bottle do
    cellar :any
    sha256 "275bc3bad4478cce3c21090e97cc1053903731f394271d0fa215835802c01cc7" => :big_sur
    sha256 "e234edab3b84eaa2127ddcaf4a722467a438d69e70fc2e27e3165d18c9cd430f" => :catalina
    sha256 "d5b7863a05ee6124b1be59fc94c4839d6479f7d0af5bb3e2cff377ec3d3720b0" => :mojave
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DBUILD_SHARED_LIBS=ON"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <ilbc.h>
      #include <stdio.h>

      int main() {
        char version[255];

        WebRtcIlbcfix_version(version);
        printf("%s", version);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lilbc", "-o", "test"
    system "./test"
  end
end
