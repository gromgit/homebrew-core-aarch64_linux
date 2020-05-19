class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.2.141.tar.gz"
  sha256 "328a4b04e5e9206db64c4da543e725be551c486b91bb4d74a253fc115f83b4c8"

  bottle do
    cellar :any_skip_relocation
    sha256 "a54f029012dc14fc6b475662d228595428d03d4c51bedebabec7da6ad7f9bd69" => :catalina
    sha256 "a54f029012dc14fc6b475662d228595428d03d4c51bedebabec7da6ad7f9bd69" => :mojave
    sha256 "a54f029012dc14fc6b475662d228595428d03d4c51bedebabec7da6ad7f9bd69" => :high_sierra
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
