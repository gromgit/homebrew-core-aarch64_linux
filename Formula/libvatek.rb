class Libvatek < Formula
  desc "User library to control VATek chips"
  homepage "https://github.com/VisionAdvanceTechnologyInc/vatek_sdk_2"
  url "https://github.com/VisionAdvanceTechnologyInc/vatek_sdk_2/archive/v3.07.tar.gz"
  sha256 "4b65b89ef4aa010f987ef9b59cae06903fd2d086d4f7346c53402efeb9035d3f"
  license "BSD-2-Clause"
  head "https://github.com/VisionAdvanceTechnologyInc/vatek_sdk_2.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "96da317a59c8873a93302b32ddf1eb78a480c4c8bb6a73317ffceebbc539dd9b"
    sha256 cellar: :any,                 arm64_big_sur:  "78b685a5b746122d5e4ed06e3e865b65ad26eab10aef75bd29ff42085e66d6c3"
    sha256 cellar: :any,                 monterey:       "e63e70729565a12f45264e222a66a589ea233a14907996fac1f1f75a99355dee"
    sha256 cellar: :any,                 big_sur:        "14b4c46d76b5814871c1de3957d517e7d42b35fde4da0e933f93bcd7bb05be9a"
    sha256 cellar: :any,                 catalina:       "28e75865e5dcca69a9f65b353cc63cc9c3b24f6c9f04199093ab48c0943dae04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc0d323290079069b38c71f89b9f02aa8ee987c930c0bb4de6e808a3d6bdab8d"
  end

  depends_on "cmake" => :build
  depends_on "libusb"

  def install
    system "cmake", "-S", ".", "-B", "builddir",
                    "-DSDK2_EN_QT=OFF", "-DSDK2_EN_APP=OFF", "-DSDK2_EN_SAMPLE=OFF",
                    *std_cmake_args
    system "cmake", "--build", "builddir"
    system "cmake", "--install", "builddir"
  end

  test do
    (testpath/"vatek_test.c").write <<~EOS
      #include <vatek_sdk_device.h>
      #include <stdio.h>
      #include <stdlib.h>

      int main()
      {
          hvatek_devices hdevices = NULL;
          vatek_result devcount = vatek_device_list_enum(DEVICE_BUS_USB, service_transform, &hdevices);
          if (is_vatek_success(devcount)) {
              printf("passed\\n");
              return EXIT_SUCCESS;
          }
          else {
              printf("failed\\n");
              return EXIT_FAILURE;
          }
      }
    EOS
    system ENV.cc, "vatek_test.c", "-I#{include}/vatek", "-L#{lib}", "-lvatek_core", "-o", "vatek_test"
    assert_equal "passed", shell_output("./vatek_test").strip
  end
end
