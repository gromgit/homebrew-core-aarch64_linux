class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.2.159.tar.gz"
  sha256 "e911e1a2c1aba468d2e1728095a4c035a7a0fe01828f089bbc5598ce05aa5be3"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "29a2e1a553729c0972aa4318f54cb9d00f06c3ce56cdd2d4a9ee8ca1a2511cf0" => :catalina
    sha256 "a6549310f316e5bfb729bdee4cad8e5f4050ebb11ab92e6fabf5966bba8e87fc" => :mojave
    sha256 "2f9e2c31f6e0f7d143bd6c9d1e4afc01154a1d38868903b6b9689ef33b44081e" => :high_sierra
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
