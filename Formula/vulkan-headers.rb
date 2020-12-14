class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.2.165.tar.gz"
  sha256 "3f9435a93ba13d94d0c3265a47e0436579e46bb9ca085e9b16a753458e4d79d2"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "a771ce8597a642442257f6331449967748371b7628c710ea8100a0bcfb8d01ec" => :big_sur
    sha256 "aca02b40a75e25430c6a4efd4ee2ea0a7a2b9ecac6ce1988627053c72ec4dc3b" => :catalina
    sha256 "641f78865ffde3c78fd2d0d786d9c8a61f0388443fe93f9f8ece6242afd1ee48" => :mojave
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
