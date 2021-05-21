class Embree < Formula
  desc "High-performance ray tracing kernels"
  homepage "https://embree.github.io/"
  url "https://github.com/embree/embree/archive/v3.12.2.tar.gz"
  sha256 "22a527622497e07970e733f753cc9c10b2bd82c3b17964e4f71a5fd2cdfca210"
  license "Apache-2.0"
  revision 1
  head "https://github.com/embree/embree.git"

  bottle do
    sha256 cellar: :any, big_sur:  "147073c0b4202455903fcc3a3e76bca5bfc8d3626e3cba03569ab28e8165be03"
    sha256 cellar: :any, catalina: "0a5d7be8af333327b71067dd361cc23018bb416aca55cea94d0a478151470011"
    sha256 cellar: :any, mojave:   "8138f4d8085ff6487008954faac6929a5b16dea7d37875030417dbe6502f09bf"
  end

  depends_on "cmake" => :build
  depends_on "ispc" => :build
  depends_on "tbb"

  def install
    max_isa = MacOS.version.requires_sse42? ? "SSE4.2" : "SSE2"

    args = std_cmake_args + %W[
      -DBUILD_TESTING=OFF
      -DEMBREE_IGNORE_CMAKE_CXX_FLAGS=OFF
      -DEMBREE_ISPC_SUPPORT=ON
      -DEMBREE_MAX_ISA=#{max_isa}
      -DEMBREE_TUTORIALS=OFF
    ]

    mkdir "build" do
      system "cmake", *args, ".."
      system "make"
      system "make", "install"
    end

    # Remove bin/models directory and the resultant empty bin directory since
    # tutorials are not enabled.
    rm_rf bin
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <assert.h>
      #include <embree3/rtcore.h>
      int main() {
        RTCDevice device = rtcNewDevice("verbose=1");
        assert(device != 0);
        rtcReleaseDevice(device);
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lembree3"
    system "./a.out"
  end
end
