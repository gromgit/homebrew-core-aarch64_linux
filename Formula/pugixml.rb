class Pugixml < Formula
  desc "Light-weight C++ XML processing library"
  homepage "https://pugixml.org/"
  url "https://github.com/zeux/pugixml/releases/download/v1.11.3/pugixml-1.11.3.tar.gz"
  sha256 "aa2a4b8a8907c01c914da06f3a8630d838275c75d1d5ea03ab48307fd1913a6d"
  license "MIT"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any
    sha256 "9e59b68193e7d86a991df19b65680d574226df446c3f7081259ca9103cdb950b" => :big_sur
    sha256 "5f2fedef33525f95a64ae2d3e954c4aff513899cc10b2f3332b740fc44843760" => :catalina
    sha256 "1305b001f9167f99d5f28c974a0a3237c1c89b2072c8edb2da56802ebc6040e4" => :mojave
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", "-DBUILD_SHARED_LIBS=ON",
                         "-DBUILD_PKGCONFIG=ON", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <pugixml.hpp>
      #include <cassert>
      #include <cstring>

      int main(int argc, char *argv[]) {
        pugi::xml_document doc;
        pugi::xml_parse_result result = doc.load_file("test.xml");

        assert(result);
        assert(strcmp(doc.child_value("root"), "Hello world!") == 0);
      }
    EOS

    (testpath/"test.xml").write <<~EOS
      <root>Hello world!</root>
    EOS

    system ENV.cxx, "test.cpp", "-o", "test", "-I#{include}",
                    "-L#{lib}", "-lpugixml"
    system "./test"
  end
end
