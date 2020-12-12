class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://github.com/sciapp/gr/archive/v0.53.0.tar.gz"
  sha256 "a348602c3e2d928b5c293a19ed91e126bf56e23720d4f0e12aa92767da767276"
  license "MIT"
  revision 2

  bottle do
    sha256 "74e780077f603713e35d583f2db4fef09a80f012c76f5ca35472a4fe875459fc" => :big_sur
    sha256 "8ea42749d5fe7799b1c18a184141990e847ae7a05b980d04a76b0416e7d37edb" => :catalina
    sha256 "d0b0b7a1d0da60f9c42256f7975f648ef81f58040d4e1d92544a5b1a681b8da8" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "cairo"
  depends_on "glfw"
  depends_on "libtiff"
  depends_on "qhull"
  depends_on "qt"
  depends_on "zeromq"

  # Use .dylib extension on macOS
  # https://github.com/sciapp/gr/pull/128
  patch do
    url "https://github.com/sciapp/gr/commit/81f6f66b9766eb876e64dff43a6b1a802536ccac.patch?full_index=1"
    sha256 "15dd98e65172a7354dc27d4858c6e06ccafa040d451171bf5e770596668478d4"
  end

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
