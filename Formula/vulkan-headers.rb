class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.2.136.tar.gz"
  sha256 "d67e61ade037906d76ae4f1a6d5adf38008b30783774a5957a84527f3a5ebdb4"

  bottle do
    cellar :any_skip_relocation
    sha256 "c38aea22142ee1e8974a28ea4d89066f0f67e421a749627fb599531b35166544" => :catalina
    sha256 "c38aea22142ee1e8974a28ea4d89066f0f67e421a749627fb599531b35166544" => :mojave
    sha256 "c38aea22142ee1e8974a28ea4d89066f0f67e421a749627fb599531b35166544" => :high_sierra
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
