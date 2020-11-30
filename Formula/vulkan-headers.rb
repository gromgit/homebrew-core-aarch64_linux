class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.2.163.tar.gz"
  sha256 "68adb4739aaea4c6da7e4d2050956b3902e9cf3c5b1efbb590294fb2cb506fec"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "b097e4cca1efcc34c2165f571de749df0db758c7349d92dabac7ed1dffc5bbea" => :big_sur
    sha256 "ac6765c9c48727ebc05891c12727f66306249090c7f6391da328ca83a1f9140f" => :catalina
    sha256 "265d5202915dffcc649cc4738609fb441570e6b42f4bda475ddf5d3580a40126" => :mojave
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
