class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.2.161.tar.gz"
  sha256 "0738f981c291743c2cb6024911fa1ecdfe1bdac67da6644019aeeff0925b5859"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "7f240b89c18d3dbe05a52f891688c1ceacdfb0f2afb3d393eb846c23d64442b6" => :big_sur
    sha256 "6c191b51b49ecda4cacb578ad944e63d626784135cbc467c837010d66ff2dd79" => :catalina
    sha256 "e821c64a708cab7e30777abd29390e4ed34e9a9b4998338f5f8d7ecae9f58f26" => :mojave
    sha256 "09161ad797df360d986fb964a5e4813d14b8ffc91b38e2f8fae13ec235756aab" => :high_sierra
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
