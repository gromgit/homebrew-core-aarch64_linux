class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.2.198.tar.gz"
  sha256 "0b2c69bc392a0022652f65efe5c51ec39ae90ec427065a914ba74ac6c728db30"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bd01995ab7a1c72cb2c6fc13c50faa700e35e976fc012d929909a52a014f325c"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--install", "build"
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
