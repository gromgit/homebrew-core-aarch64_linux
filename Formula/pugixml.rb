class Pugixml < Formula
  desc "Light-weight C++ XML processing library"
  homepage "https://pugixml.org/"
  url "https://github.com/zeux/pugixml/releases/download/v1.11.3/pugixml-1.11.3.tar.gz"
  sha256 "aa2a4b8a8907c01c914da06f3a8630d838275c75d1d5ea03ab48307fd1913a6d"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "5d7799fddd33ce3760df300562b251806a3560719b71f1e9ca4203b3bd61d2d1" => :big_sur
    sha256 "0ffe1ff4b0acfd016b43732e77b56859cf19f8de62490cd56a35bff1f24b4de4" => :catalina
    sha256 "1e0af8b0b1520df532500f7da2a1c6997f8085906b0c12a74d6fcd322c14c49f" => :mojave
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", "-DBUILD_SHARED_LIBS=OFF",
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
