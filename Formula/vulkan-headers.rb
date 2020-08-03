class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.2.149.tar.gz"
  sha256 "332e35104a911447915ccf03f2d61d7e061d3cf5a09419a032b3b09246dcca85"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "c370cba4d9d06d7d99cb7bf966e5e05c198a490e66584e06d98949f5715b9b0e" => :catalina
    sha256 "c370cba4d9d06d7d99cb7bf966e5e05c198a490e66584e06d98949f5715b9b0e" => :mojave
    sha256 "c370cba4d9d06d7d99cb7bf966e5e05c198a490e66584e06d98949f5715b9b0e" => :high_sierra
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
