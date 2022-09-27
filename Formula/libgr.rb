class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://github.com/sciapp/gr/archive/v0.69.0.tar.gz"
  sha256 "7708093220f4068611f27bc7c784ec16bdba7c53533a3e6e9e8ad8b0dbce6721"
  license "MIT"

  bottle do
    sha256 arm64_monterey: "e49fceb434c9e8a1c604eed924117f8146dd7ac4d44eb4e9cb6f83d07468af01"
    sha256 arm64_big_sur:  "fd68403489252b49e4ce41d9c12f3991bd16025c483bbb0bc12a3652dcb7accb"
    sha256 monterey:       "7df4345e4db9f60f0f38ed5f81db1f94641c3947a521653371feb8ba59bd2d91"
    sha256 big_sur:        "244230e8a7b590b549fb81878e8d0035da0d29b874fa1781424540a2c981f4fe"
    sha256 catalina:       "16a16a155c18ae023daa93f896d0fe3ed6bed6394e3044075474fcef0e7836a5"
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
