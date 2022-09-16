class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://github.com/sciapp/gr/archive/v0.67.0.tar.gz"
  sha256 "5cdd5baf574a1bb3d24f6f18b44cb6eabff10fed3fccab576ec91b24b17b8ad9"
  license "MIT"

  bottle do
    sha256 arm64_monterey: "e42bd7ff4c40c572d57abf6be9fb1c575f6a19ca721d544e6fd179d66ad5cd49"
    sha256 arm64_big_sur:  "785e5634530116cca5c665efab7606bb72b5d5af1b21f9f5e7ba841018dfb7ee"
    sha256 monterey:       "77b5dc85a7d4402ae28bc86899eea483f86ede68da31dda4910946393205089b"
    sha256 big_sur:        "92b55d4268652dc3a438f8f2efb340a50701a0d494aa7eb770104fd2de05eab2"
    sha256 catalina:       "424bf1f843e8bef527382258cc60255bc0be20d9b7dc838ec3b82247ac0fcd79"
  end

  depends_on "cmake" => :build
  depends_on "cairo"
  depends_on "glfw"
  depends_on "libtiff"
  depends_on "qhull"
  depends_on "qt"
  depends_on "zeromq"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <gr.h>

      int main(void) {
          gr_opengks();
          gr_openws(1, "test.png", 140);
          gr_activatews(1);
          double x[] = {0, 0.2, 0.4, 0.6, 0.8, 1.0};
          double y[] = {0.3, 0.5, 0.4, 0.2, 0.6, 0.7};
          gr_polyline(6, x, y);
          gr_axes(gr_tick(0, 1), gr_tick(0, 1), 0, 0, 1, 1, -0.01);
          gr_updatews();
          gr_emergencyclosegks();
          return 0;
      }
    EOS

    system ENV.cc, "test.c", "-o", "test", "-I#{include}", "-L#{lib}", "-lGR"
    system "./test"

    assert_predicate testpath/"test.png", :exist?
  end
end
