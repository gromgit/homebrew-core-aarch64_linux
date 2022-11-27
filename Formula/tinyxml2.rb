class Tinyxml2 < Formula
  desc "Improved tinyxml (in memory efficiency and size)"
  homepage "http://grinninglizard.com/tinyxml2"
  url "https://github.com/leethomason/tinyxml2/archive/9.0.0.tar.gz"
  sha256 "cc2f1417c308b1f6acc54f88eb70771a0bf65f76282ce5c40e54cfe52952702c"
  license "Zlib"
  head "https://github.com/leethomason/tinyxml2.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/tinyxml2"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "85028d3d234c5fb8c5cc1bf2ad1109b8312db2c029a1493f3e2f650f353d3f7c"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args, "-Dtinyxml2_SHARED_LIBS=ON"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <tinyxml2.h>
      int main() {
        tinyxml2::XMLDocument doc (false);
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-L#{lib}", "-ltinyxml2", "-o", "test"
    system "./test"
  end
end
