class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.2.203.tar.gz"
  sha256 "7239108c372f1fbe365bd8d1610ca2bb4e72b73b2151f2551bf9df54dd539639"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "34738cf988a7791d62e692e0a0c34f7a50b3f0291a56ef9cac7eca5868bbc22a"
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
