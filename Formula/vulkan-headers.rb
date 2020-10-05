class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.2.156.tar.gz"
  sha256 "1842e7cade4ee1abf8486d7789734085e77685a0a76626a15204a5c4f203879e"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "350afdd580434b9c5220e908ede864e88b67c5c502f138bfec7d47f6dc0cf736" => :catalina
    sha256 "7c368e9a0d4cb2ee30b26a15f4e6c6627431c35eac29359fd0f5f31ba2c04af4" => :mojave
    sha256 "d5d10312e4fceb39c1cadb1e7e7c54d7371e9418f02cde7db816800a7bfa076d" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <vulkan/vulkan_core.h>

      int main() {
        printf("vulkan version %d", VK_VERSION_1_0);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-o", "test"
    system "./test"
  end
end
