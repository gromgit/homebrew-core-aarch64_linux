class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.2.172.tar.gz"
  sha256 "c69619ac2001ac62378a99c56ced14a53801fdc204efb2b1f787c83b47829319"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "15bb5201c7f58c17f0210bf429905376ea1d58b2a46bd0fc00f40c8d026fc927"
    sha256 cellar: :any_skip_relocation, big_sur:       "6721d9160ac068df7d08a059a9243f06cb16590f6e816630d6e2d0b61377613c"
    sha256 cellar: :any_skip_relocation, catalina:      "bbc7555fb4d6d580f990b00267038aef208399c65d2f97bd845b1460f6f5a300"
    sha256 cellar: :any_skip_relocation, mojave:        "105b90d17804b6faf18bcbd44da93adfbcb009befff844d9788195c554fbcac5"
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
