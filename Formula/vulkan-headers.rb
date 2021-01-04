class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.2.166.tar.gz"
  sha256 "75d77088a75e604d0a84b291a385d82ccf78e0e51df788b891bdd595eb80be51"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "8fe36cfa138636a4adc96057b2ddda936fe81c510652785ad5e009657eb917ca" => :big_sur
    sha256 "856a17456e08ccd9891e863ce2e808b18b24ab2e6ec0a55356e1d893262fd630" => :arm64_big_sur
    sha256 "0e42dab0ec02843eeb8d5d2d6192fc0f3d4c923a54b258c38589a83142bf7ff9" => :catalina
    sha256 "15bb5f8e9b8ad44e6413346647a7dea5b99aafa5cf3136f4b5dc053072086c42" => :mojave
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
