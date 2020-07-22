class Ospray < Formula
  desc "Ray-tracing-based rendering engine for high-fidelity visualization"
  homepage "https://www.ospray.org/"
  url "https://github.com/ospray/ospray/archive/v2.2.0.tar.gz"
  sha256 "7078cc7c7a6e709589f8cb15a150947bb1b93f00d08f8a2ef3f5e368d57a3797"
  license "Apache-2.0"
  head "https://github.com/ospray/ospray.git"

  bottle do
    cellar :any
    sha256 "c8c5b0e3f26cde1dececff86042892c96e85421afc71d76f4c52d5ca587aefd1" => :catalina
    sha256 "74c6cd09e7a63e0f31cc5045f9f1d9c298a6d3a470ed8db837f9683e707e0f75" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "ispc" => :build
  depends_on "embree"
  depends_on :macos => :mojave # Needs embree bottle built with SSE4.2.
  depends_on "tbb"

  resource "rkcommon" do
    url "https://github.com/ospray/rkcommon/archive/v1.4.2.tar.gz"
    sha256 "2d1c0046cf583d3040fc9bb3b8ddcb1a2262d3f48aebd0973e6bd6cabb487f9e"
  end

  resource "openvkl" do
    url "https://github.com/openvkl/openvkl/archive/v0.10.0.tar.gz"
    sha256 "b75caabd5e0211e8c29dd9bd04a74c9ed30a1a72413c486206144c25fd31afff"
  end

  def install
    resources.each do |r|
      r.stage do
        mkdir "build" do
          system "cmake", "..", *std_cmake_args,
                                "-DBUILD_EXAMPLES=OFF",
                                "-DBUILD_TESTING=OFF"
          system "make"
          system "make", "install"
        end
      end
    end

    args = std_cmake_args + %W[
      -DCMAKE_INSTALL_NAME_DIR=#{opt_lib}
      -DCMAKE_INSTALL_RPATH=#{opt_lib}
      -DOSPRAY_ENABLE_APPS=OFF
      -DOSPRAY_ENABLE_TESTING=OFF
      -DOSPRAY_ENABLE_TUTORIALS=OFF
    ]

    mkdir "build" do
      system "cmake", *args, ".."
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <assert.h>
      #include <ospray/ospray.h>
      int main(int argc, const char **argv) {
        OSPError error = ospInit(&argc, argv);
        assert(error == OSP_NO_ERROR);
        ospShutdown();
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lospray"
    system "./a.out"
  end
end
