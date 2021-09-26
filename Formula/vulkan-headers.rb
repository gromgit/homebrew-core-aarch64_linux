class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.2.193.tar.gz"
  sha256 "52e039b91a27fa2a9e9fa8e39803df1b57cf803c27b67f67d74ba5eacdaf864e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b939280ce88256336c9bcde4eee2d487f8068972fef3ac1716c9743531607e36"
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
