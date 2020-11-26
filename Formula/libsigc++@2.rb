class LibsigcxxAT2 < Formula
  desc "Callback framework for C++"
  homepage "https://libsigcplusplus.github.io/libsigcplusplus/"
  url "https://download.gnome.org/sources/libsigc++/2.10/libsigc++-2.10.6.tar.xz"
  sha256 "dda176dc4681bda9d5a2ac1bc55273bdd381662b7a6d49e918267d13e8774e1b"
  license "LGPL-3.0-or-later"

  bottle do
    cellar :any
    sha256 "b13a8c4ad6256012ae43049d84c045866f6c51e3ffbeea2cadb5927230e8696c" => :big_sur
    sha256 "7154ac476939a124a9fce607a2e04179f769a942e4faac24f9e15d4e408d0bb1" => :catalina
    sha256 "2ed859eacbb9d12487be891f1b3f06b1b5fffb1ccac3af37787ac174fabd934d" => :mojave
    sha256 "0b46ff09499e252f0821f22cc1deff57a332130a807928bd018bdb4145705bac" => :high_sierra
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    ENV.cxx11

    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <sigc++/sigc++.h>

      void somefunction(int arg) {}

      int main(int argc, char *argv[])
      {
         sigc::slot<void, int> sl = sigc::ptr_fun(&somefunction);
         return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp",
                   "-L#{lib}", "-lsigc-2.0", "-I#{include}/sigc++-2.0", "-I#{lib}/sigc++-2.0/include", "-o", "test"
    system "./test"
  end
end
