class Libxkbcommon < Formula
  desc "Keyboard handling library"
  homepage "https://xkbcommon.org/"
  url "https://xkbcommon.org/download/libxkbcommon-0.9.1.tar.xz"
  sha256 "d4c6aabf0a5c1fc616f8a6a65c8a818c03773b9a87da9fbc434da5acd1199be0"
  head "https://github.com/xkbcommon/libxkbcommon.git"

  bottle do
    cellar :any
    sha256 "b092312f682e9cbd6f2b1918dfdc57e3ba18038945bdd0d98558ca5605a852e0" => :catalina
    sha256 "d11930a50f52bee01e250ae80e1972a12f10a422bb885df42befdb4784f3a983" => :mojave
    sha256 "da3a6ad4c591da868a4aeb245b9311181a03d4392e82cc5159d24740c8695b86" => :high_sierra
    sha256 "6b78ab52d77c4c1c81485d4071298a38a78ec1d74e55e57786d833ea8ecc58af" => :sierra
  end

  depends_on "bison" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on :x11

  def install
    mkdir "build" do
      system "meson", "--prefix=#{prefix}", "-Denable-wayland=false", "-Denable-docs=false", ".."
      system "ninja", "install", "-v"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdlib.h>
      #include <xkbcommon/xkbcommon.h>
      int main() {
        return (xkb_context_new(XKB_CONTEXT_NO_FLAGS) == NULL)
          ? EXIT_FAILURE
          : EXIT_SUCCESS;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lxkbcommon",
                   "-o", "test"
    system "./test"
  end
end
