class Libgosu < Formula
  desc "2D game development library"
  homepage "https://libgosu.org"
  url "https://github.com/gosu/gosu/archive/v1.0.0.tar.gz"
  sha256 "0b3f6ff095808fc1dbfc8513676737dc2cf99a8570013873eaab64499b543331"
  license "MIT"
  head "https://github.com/gosu/gosu.git"

  bottle do
    cellar :any
    sha256 "d6afbd6af6184ff1e51f4dbe580ff8f19f11235d8dde4f9834951f4079070831" => :big_sur
    sha256 "b6a28109e1504d9640bd25b4e76112c873b00e72c319c66aa32c8a44851fd72f" => :arm64_big_sur
    sha256 "bfdc72d6d978814a4ef914605de1b0969c7d3ca62fb98b035c3be0120a9cf168" => :catalina
    sha256 "442d1168c40e34104c445df179e9482d1d03a359d5cc7676f589ce3d42289093" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "sdl2"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <stdlib.h>
      #include <Gosu/Gosu.hpp>

      class MyWindow : public Gosu::Window
      {
      public:
          MyWindow()
          :   Gosu::Window(640, 480)
          {
              set_caption(\"Hello World!\");
          }

          void update()
          {
              exit(0);
          }
      };

      int main()
      {
          MyWindow window;
          window.show();
      }
    EOS

    system ENV.cxx, "test.cpp", "-o", "test", "-L#{lib}", "-lgosu", "-I#{include}", "-std=c++11"
    system "./test"
  end
end
