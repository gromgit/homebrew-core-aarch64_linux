class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.2.140.tar.gz"
  sha256 "c708a05b0ef673ae783f8968c5396dc207b9f8c7cde2ddb4a9a281e04661185a"

  bottle do
    cellar :any_skip_relocation
    sha256 "a97e131d8ee777b8f73120dcaf8a1d22ccb52859367f8f80547f2870f77db342" => :catalina
    sha256 "a97e131d8ee777b8f73120dcaf8a1d22ccb52859367f8f80547f2870f77db342" => :mojave
    sha256 "a97e131d8ee777b8f73120dcaf8a1d22ccb52859367f8f80547f2870f77db342" => :high_sierra
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
