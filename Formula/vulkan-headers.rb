class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.2.153.tar.gz"
  sha256 "c74e8b007771c8db4f028159ec7436e76333bf7e937f91c0bec3ba0e63cb3978"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "1a3e7e3813d2121cd84a9800566e76a713d13631d6ec499564b7f8e550e0ad20" => :catalina
    sha256 "30f6e616afce47cba8c73be24fdb60dab3f6369928bba5f9e580494f49d556e1" => :mojave
    sha256 "db4451c40caf1fbdd4215371a8aee9ee68695f90aa14c6bcf7fb1b36e3bf9fb3" => :high_sierra
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
