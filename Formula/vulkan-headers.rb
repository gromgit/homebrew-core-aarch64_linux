class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.2.182.tar.gz"
  sha256 "38d1c953de7bb2d839556226851feeb690f0d23bc22ac46c823dcb66c97bfdc8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2107441497b37bc9c7f74291599a85fb6892da77f78de5799c1cd8e493fdad55"
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
