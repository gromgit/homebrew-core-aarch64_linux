class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.2.157.tar.gz"
  sha256 "dbc121f58641acd45c386ee96ecd5e10a124c489087443d7367fff4b53b49283"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "a42128584dc123650d70d27ea12f3badc89e1cde17732280af5381204bda7b63" => :catalina
    sha256 "2ab32d7a2e03a555c4fa121eb9d410c6b09f2958c129568f17d1c5a976bf50af" => :mojave
    sha256 "934cb9c86f29ff022fd3a66cf33c5b45ad47caec58a9f1038a06af410a39e66e" => :high_sierra
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
