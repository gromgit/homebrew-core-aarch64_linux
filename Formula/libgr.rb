class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://github.com/sciapp/gr/archive/v0.69.0.tar.gz"
  sha256 "7708093220f4068611f27bc7c784ec16bdba7c53533a3e6e9e8ad8b0dbce6721"
  license "MIT"

  bottle do
    sha256 arm64_monterey: "2acb3110dd7a322a355574a1e3b80acb0a10c8694563ba143e3dba17702c5ede"
    sha256 arm64_big_sur:  "e885bd815ac09dd4df3161adbbe1861474195cfec7c89031be1d91c1567f900a"
    sha256 monterey:       "8274ac558f60ebef3b13e55a0f40b8e4943096c11fa5f9a6254c8ba5c54c0b0d"
    sha256 big_sur:        "ad6eb134ca6da4a282ecb6379d922d10e867e5715871d78c6b28b84df8d13f58"
    sha256 catalina:       "ab39a4f1773bc0399fca04e7f764e4b3f84ff3c0b4f1d52d356e5d0422ef1b57"
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
