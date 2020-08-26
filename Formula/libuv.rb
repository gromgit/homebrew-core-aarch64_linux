class Libuv < Formula
  desc "Multi-platform support library with a focus on asynchronous I/O"
  homepage "https://github.com/libuv/libuv"
  url "https://github.com/libuv/libuv/archive/v1.39.0.tar.gz"
  sha256 "dc7b21f1bb7ef19f4b42c5ea058afabe51132d165da18812b70fb319659ba629"
  license "MIT"
  head "https://github.com/libuv/libuv.git", branch: "v1.x"

  bottle do
    cellar :any
    sha256 "dec21e413749391240327cdceb61306a7af572f2d1a5c5b3d2f489a7030dcce0" => :catalina
    sha256 "ee152b665f1af6fca06348a44907a5af34b4f57c2df3ac4c37f2be9e920badb0" => :mojave
    sha256 "5079aa951e6ba6bbad83101bf7eb41c7ba218e20bebcdbd9efe6300eeadd6b1a" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build

  def install
    # This isn't yet handled by the make install process sadly.
    cd "docs" do
      system "make", "man"
      system "make", "singlehtml"
      man1.install "build/man/libuv.1"
      doc.install Dir["build/singlehtml/*"]
    end

    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <uv.h>
      #include <stdlib.h>

      int main()
      {
        uv_loop_t* loop = malloc(sizeof *loop);
        uv_loop_init(loop);
        uv_loop_close(loop);
        free(loop);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-luv", "-o", "test"
    system "./test"
  end
end
