class Libepoxy < Formula
  desc "Library for handling OpenGL function pointer management"
  homepage "https://github.com/anholt/libepoxy"
  url "https://download.gnome.org/sources/libepoxy/1.5/libepoxy-1.5.5.tar.xz"
  sha256 "261663db21bcc1cc232b07ea683252ee6992982276536924271535875f5b0556"
  license "MIT"

  # We use a common regex because libepoxy doesn't use GNOME's "even-numbered
  # minor is stable" version scheme.
  livecheck do
    url :stable
    regex(/libepoxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "73fb58d2b0cf8a1283a0ff7216cb669f306b95f15721a61142831a5fa31094e5" => :big_sur
    sha256 "bced3ab3b1d51b3693275b58c74fc29713e5757c681db3e148daa38ed9810ab8" => :arm64_big_sur
    sha256 "9f58a2eab6aafcc95ade6893bde8d878ab422284353e22c11d04c3a6f3a1e7cb" => :catalina
    sha256 "e42a0410e6f94fa419f785c5b0901eea1506242b1729f97b672f25b463ce3d4e" => :mojave
    sha256 "95cbc3ce1fc94931e0259f9e55a25d9dcacacd70713ae3e59cba28f3d7ff2a3a" => :high_sierra
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build

  def install
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS

      #include <epoxy/gl.h>
      #include <OpenGL/CGLContext.h>
      #include <OpenGL/CGLTypes.h>
      #include <OpenGL/OpenGL.h>
      int main()
      {
          CGLPixelFormatAttribute attribs[] = {0};
          CGLPixelFormatObj pix;
          int npix;
          CGLContextObj ctx;

          CGLChoosePixelFormat( attribs, &pix, &npix );
          CGLCreateContext(pix, (void*)0, &ctx);

          glClear(GL_COLOR_BUFFER_BIT);
          CGLReleasePixelFormat(pix);
          CGLReleaseContext(pix);
          return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lepoxy", "-framework", "OpenGL", "-o", "test"
    system "ls", "-lh", "test"
    system "file", "test"
    system "./test"
  end
end
