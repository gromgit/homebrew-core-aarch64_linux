class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.2.153.tar.gz"
  sha256 "c74e8b007771c8db4f028159ec7436e76333bf7e937f91c0bec3ba0e63cb3978"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "834af93ce9e28d87de23729dccef046596fb7f36000eb8399e443e5c3700abd4" => :catalina
    sha256 "16ddaa9e2c87a080b2e71fbc372c686fc170ad998cac621e868c34fd3c1156b6" => :mojave
    sha256 "7c9815a6c381af86c2efd5a8aef753c9e85f38c2e880c71cc07bc4138c125023" => :high_sierra
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
