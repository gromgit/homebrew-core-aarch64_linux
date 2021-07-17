class Openfpgaloader < Formula
  desc "Universal utility for programming FPGA"
  homepage "https://github.com/trabucayre/openFPGALoader"
  url "https://github.com/trabucayre/openFPGALoader/archive/v0.4.0.tar.gz"
  sha256 "f2a67761a6fc66b5f1ba61618ea73852e3d4d7ea7166f32ea0a3274a908c6d11"
  license "Apache-2.0"
  head "https://github.com/trabucayre/openFPGALoader.git"

  bottle do
    sha256 arm64_big_sur: "0b0ff606f9c897ac366cda2c8f4aeb297d235910a3e94a3fe75c6c477dac2c4a"
    sha256 big_sur:       "023de89dec4bdccd8222433be4d20587288d4c30aeadec27c71ac9192e992bee"
    sha256 catalina:      "7399ee5c7f0d1693867a33b423a55f2c6968bdcedfeb1d0c88c27e50c4d091cb"
    sha256 mojave:        "6d2efdb166f86a10ae3a3c7b25989859159b2be2b63dc6cc69e874b2b6febaa1"
    sha256 x86_64_linux:  "1fbca000552a9bb330257c05ce2c173c65d82c544699457e25d2939198da9fe3"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libftdi"
  depends_on "libusb"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    version_output = shell_output("#{bin}/openFPGALoader -V 2>&1")
    assert_match "openFPGALoader v#{version}", version_output

    error_output = shell_output("#{bin}/openFPGALoader --detect 2>&1 >/dev/null", 1)
    assert_includes error_output, "JTAG init failed"
  end
end
