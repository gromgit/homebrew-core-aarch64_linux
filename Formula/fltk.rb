class Fltk < Formula
  desc "Cross-platform C++ GUI toolkit"
  homepage "https://www.fltk.org/"
  url "https://www.fltk.org/pub/fltk/1.3.7/fltk-1.3.7-source.tar.gz"
  sha256 "5d2ccb7ad94e595d3d97509c7a931554e059dd970b7b29e6fd84cb70fd5491c6"
  license "LGPL-2.0-only" => { with: "FLTK-exception" }

  livecheck do
    url "https://www.fltk.org/software.php"
    regex(/href=.*?fltk[._-]v?(\d+(?:\.\d+)+(?:-\d+)?)-source\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "8a38a916979fe3cd382d683bcd0c0cea2322a1754024e6afe99c9c9591bb8724"
    sha256 big_sur:       "ec58967d86a8068d770f5c1f8a5650ff7a4c334d952b51220564e1539b1c54de"
    sha256 catalina:      "94960f1fd2d833812056ef8d8be09b563331277b6b30b49e527d2a28d1454fb8"
    sha256 mojave:        "137faeafeb34fe3517d79aebb9c3fcfb2c959729e46d59d62be6203c2a520f39"
    sha256 x86_64_linux:  "51aeebe6988201f1acdc00c02d9e1c11a54d7abf77bcf32357b70cd16cd78d9d"
  end

  head do
    url "https://github.com/fltk/fltk.git"
    depends_on "cmake" => :build
  end

  depends_on "jpeg"
  depends_on "libpng"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libxft"
    depends_on "libxt"
    depends_on "mesa-glu"
  end

  def install
    if build.head?
      args = std_cmake_args

      # Don't build docs / require doxygen
      args << "-DOPTION_BUILD_HTML_DOCUMENTATION=OFF"
      args << "-DOPTION_BUILD_PDF_DOCUMENTATION=OFF"

      # Don't build tests
      args << "-DFLTK_BUILD_TEST=OFF"

      # Build both shared & static libs
      args << "-DOPTION_BUILD_SHARED_LIBS=ON"

      system "cmake", ".", *args
      system "cmake", "--build", "."
      system "cmake", "--install", "."
    else
      system "./configure", "--prefix=#{prefix}",
                            "--enable-threads",
                            "--enable-shared"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <FL/Fl.H>
      #include <FL/Fl_Window.H>
      #include <FL/Fl_Box.H>
      int main(int argc, char **argv) {
        Fl_Window *window = new Fl_Window(340,180);
        Fl_Box *box = new Fl_Box(20,40,300,100,"Hello, World!");
        box->box(FL_UP_BOX);
        box->labelfont(FL_BOLD+FL_ITALIC);
        box->labelsize(36);
        box->labeltype(FL_SHADOW_LABEL);
        window->end();
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lfltk", "-o", "test"
    system "./test"
  end
end
