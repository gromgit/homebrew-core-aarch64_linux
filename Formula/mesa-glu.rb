class MesaGlu < Formula
  desc "Mesa OpenGL Utility library"
  homepage "https://cgit.freedesktop.org/mesa/glu"
  url "ftp://ftp.freedesktop.org/pub/mesa/glu/glu-9.0.2.tar.xz"
  sha256 "6e7280ff585c6a1d9dfcdf2fca489251634b3377bfc33c29e4002466a38d02d4"
  license any_of: ["GPL-3.0-or-later", "GPL-2.0-or-later", "MIT", "SGI-B-2.0"]

  livecheck do
    url :head
    regex(/^(?:glu[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/mesa-glu"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "b421b54759be95044df4339ccff45b4d2e9b907a96bfa2ba2495123b80ef78f2"
  end

  head do
    url "https://gitlab.freedesktop.org/mesa/glu.git"

    depends_on "automake" => :build
  end

  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "mesa"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-silent-rules
    ]

    system "./autogen.sh", *args if build.head?
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <GL/glu.h>

      int main(int argc, char* argv[]) {
        static GLUtriangulatorObj *tobj;
        GLdouble vertex[3], dx, dy, len;
        int i = 0;
        int count = 5;
        tobj = gluNewTess();
        gluBeginPolygon(tobj);
        for (i = 0; i < count; i++) {
          vertex[0] = 1;
          vertex[1] = 2;
          vertex[2] = 0;
          gluTessVertex(tobj, vertex, 0);
        }
        gluEndPolygon(tobj);
        return 0;
      }
    EOS
    system ENV.cxx, "-I#{include}", "test.cpp", "-L#{lib}", "-lGLU"
  end
end
