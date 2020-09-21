class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.2.154.tar.gz"
  sha256 "b636f0ace2c2b8a7dbdfddf16c53c1f49a4b39d6da562727bfea00b5ec447537"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "427ecb9a25c3a84b6bf0b5c119d12d868561f53391db4eca1abb9c3065653060" => :catalina
    sha256 "9cdbf69c6a706d52d2207c4c855a5d5c5ecf8e9f72c5a95780bf9c9505ee308d" => :mojave
    sha256 "49f50b477f5dac393e15509f2af6dbb51961b87765923b4033ac3b2673179a3f" => :high_sierra
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
