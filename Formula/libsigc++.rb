class Libsigcxx < Formula
  desc "Callback framework for C++"
  homepage "https://libsigcplusplus.github.io/libsigcplusplus/"
  url "https://download.gnome.org/sources/libsigc++/3.0/libsigc++-3.0.4.tar.xz"
  sha256 "a3a37410186379df1908957e7aba7519bdcf5bcc8ed70ee8dfea9362c393d545"
  license "LGPL-3.0-or-later"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "77bf9858cb60a1842d970bbbc020a5379536806acbc4114afa56d8c941013765" => :catalina
    sha256 "7ae9cb9a4d6a645574c6cf5aba8a9cfbbab44349545374f604073393c67f6f50" => :mojave
    sha256 "e2c75abf2675c7830fd19aa268472aeee8b5c42cd9355147585bad9be7c3059a" => :high_sierra
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  depends_on macos: :high_sierra # needs C++17

  def install
    ENV.cxx11

    mkdir "build" do
      system "meson", *std_meson_args, "-Dintrospection=enabled", ".."
      system "ninja"
      system "ninja", "install"
    end
  end
  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <string>
      #include <sigc++/sigc++.h>

      void on_print(const std::string& str) {
        std::cout << str;
      }

      int main(int argc, char *argv[]) {
        sigc::signal<void(const std::string&)> signal_print;

        signal_print.connect(sigc::ptr_fun(&on_print));

        signal_print.emit("hello world\\n");
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++17", "test.cpp",
                   "-L#{lib}", "-lsigc-3.0", "-I#{include}/sigc++-3.0", "-I#{lib}/sigc++-3.0/include", "-o", "test"
    assert_match "hello world", shell_output("./test")
  end
end
