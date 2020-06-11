class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.2.143.tar.gz"
  sha256 "8965ae2c64033576690ded2f315bef67fb8b7d49a5ad27a5b7bb41816936a618"

  bottle do
    cellar :any_skip_relocation
    sha256 "51115062fdbcac4f2edd1c65cba09a19994fe32a3f6bb7dba1601833cb96ead5" => :catalina
    sha256 "51115062fdbcac4f2edd1c65cba09a19994fe32a3f6bb7dba1601833cb96ead5" => :mojave
    sha256 "51115062fdbcac4f2edd1c65cba09a19994fe32a3f6bb7dba1601833cb96ead5" => :high_sierra
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
