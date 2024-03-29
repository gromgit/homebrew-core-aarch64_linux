class LibsigcxxAT2 < Formula
  desc "Callback framework for C++"
  homepage "https://libsigcplusplus.github.io/libsigcplusplus/"
  url "https://download.gnome.org/sources/libsigc++/2.10/libsigc++-2.10.8.tar.xz"
  sha256 "235a40bec7346c7b82b6a8caae0456353dc06e71f14bc414bcc858af1838719a"
  license "LGPL-3.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/libsigc++@2"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "8b8a1d0ae9a03198cd882f89f54a93e75bb8b4f0b8e42690b0c10a41bb9cf247"
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
