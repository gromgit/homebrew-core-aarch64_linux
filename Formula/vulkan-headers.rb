class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.2.150.tar.gz"
  sha256 "dc6477b06ed04f4df72cb46915131c1a844980c6f4993954672893b69c2ffb57"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "c77034664c0ebbcc8de0107fe09c500d5ca7cd20f6f21e69e76079ec4d37f239" => :catalina
    sha256 "c77034664c0ebbcc8de0107fe09c500d5ca7cd20f6f21e69e76079ec4d37f239" => :mojave
    sha256 "c77034664c0ebbcc8de0107fe09c500d5ca7cd20f6f21e69e76079ec4d37f239" => :high_sierra
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
