class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.2.136.tar.gz"
  sha256 "d67e61ade037906d76ae4f1a6d5adf38008b30783774a5957a84527f3a5ebdb4"

  bottle do
    cellar :any_skip_relocation
    sha256 "eb897bc006c7eeccba6042419d225465030d7035a0020766ba60d850e1e84927" => :catalina
    sha256 "eb897bc006c7eeccba6042419d225465030d7035a0020766ba60d850e1e84927" => :mojave
    sha256 "eb897bc006c7eeccba6042419d225465030d7035a0020766ba60d850e1e84927" => :high_sierra
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
