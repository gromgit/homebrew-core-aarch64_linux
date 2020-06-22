class Tgui < Formula
  desc "GUI library for use with sfml"
  homepage "https://tgui.eu"
  url "https://github.com/texus/TGUI/archive/v0.8.8.tar.gz"
  sha256 "a00e34eea7dc584211b2ebbfabc026af7c261d7935c32ca77fd90ed7a6c85230"

  bottle do
    cellar :any
    sha256 "76734cad82f28f498196913bdbbb34ebe675b1b18c8a03cabe563df440102be5" => :catalina
    sha256 "a5551677fc595ffd9552e5b5cba44b24beec7a42830fbad371f1e4603092bcf9" => :mojave
    sha256 "fe0a229004ccab2f8c17a7d3ddf170e5b7d80926eb54e038866c7ea8b18e54c1" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "sfml"

  def install
    system "cmake", ".", *std_cmake_args,
                    "-DTGUI_MISC_INSTALL_PREFIX=#{pkgshare}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <TGUI/TGUI.hpp>
      int main()
      {
        sf::Text text;
        text.setString("Hello World");
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++1y", "-I#{include}",
      "-L#{lib}", "-L#{Formula["sfml"].opt_lib}",
      "-ltgui", "-lsfml-graphics", "-lsfml-system", "-lsfml-window",
      "-o", "test"
    system "./test"
  end
end
