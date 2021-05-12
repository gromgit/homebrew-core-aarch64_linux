class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.2.178.tar.gz"
  sha256 "44f19a73ac09c91f5095a9bc67e45547129ca51bdb481639aa5ac060884c95c1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e005c4564db809d53aa424ba45b8a5feb77fe0e43aaed96c9cd1cd8a90731c49"
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
