class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.2.168.tar.gz"
  sha256 "ec6a69836a8cd413f89071a9b978d0547849192538550c706a8e560089d59cb2"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "e781086ca14c672658c10388d82ef23953a4306d00c14eed2e28d57742f0e00e" => :big_sur
    sha256 "0b3e4cbebb1a15838e29724f6b8076d177b592d30de3220f488d61515a5f555f" => :arm64_big_sur
    sha256 "8fef853807df1538f2f105f70590c5f2ea674050a1381e8a6529c8be92988269" => :catalina
    sha256 "97c39cacab39150bc37cda79954ff9ee7412f9ce4da1a15478f82b8b1efd35ae" => :mojave
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
