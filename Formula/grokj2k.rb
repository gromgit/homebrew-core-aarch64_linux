class Grokj2k < Formula
  desc "JPEG 2000 Library"
  homepage "https://github.com/GrokImageCompression/grok"
  url "https://github.com/GrokImageCompression/grok/archive/v8.0.2.tar.gz"
  sha256 "ab16fee0d804fc0bf8e18d36a6ba6564d95881c5cc1d7139f9860a54f260f4d8"
  license "AGPL-3.0-or-later"
  head "https://github.com/GrokImageCompression/grok.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "7179593642f49f1019c6c9c35b2f536a76bab42446a3652052e64e0a18d476ea"
    sha256 cellar: :any, big_sur:       "b5e0fdf12d79eba607f501422c0e4a048ce89266517eb98690af4ade8b14cdd2"
    sha256 cellar: :any, catalina:      "8e6b77f7b00e790c9db6575c0400984f896b10eb44920c6f7b8fc98a07474ef8"
    sha256 cellar: :any, mojave:        "dbe5f8562ae0a02b3f791425fc0da3358701d1d3b75d28fb82350404c03e701c"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "exiftool"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "little-cms2"

  def install
    system "cmake", ".", *std_cmake_args, "-DBUILD_DOC=ON"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <grok.h>

      int main () {
        grk_image_cmptparm cmptparm;
        const GRK_COLOR_SPACE color_space = GRK_CLRSPC_GRAY;

        grk_image *image;
        image = grk_image_new(1, &cmptparm, color_space,false);

        grk_object_unref(&image->obj);
        return 0;
      }
    EOS
    system ENV.cc, "-I#{include.children.first}", "-L#{lib}", "-lgrokj2k", "test.c", "-o", "test"
    # Linux test
    # system ENV.cc, "test.c", "-I#{include.children.first}", "-L#{lib}", "-lgrokj2k", "-o", "test"
    system "./test"
  end
end
