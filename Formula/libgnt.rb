class Libgnt < Formula
  desc "NCurses toolkit for creating text-mode graphical user interfaces"
  homepage "https://keep.imfreedom.org/libgnt/libgnt"
  url "https://downloads.sourceforge.net/project/pidgin/libgnt/2.14.1/libgnt-2.14.1.tar.xz"
  sha256 "5ec3e68e18f956e9998d79088b299fa3bca689bcc95c86001bc5da17c1eb4bd8"
  license "GPL-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/libgnt[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "bddb1f3389bb8c76b175d2fd5df1418d0ae5f91f153034b42a0b3794c2a445ee"
    sha256 cellar: :any, big_sur:       "5f793a61de68c97843ff17f339c287d24a32f1562f21d524e181d2b730604b49"
    sha256 cellar: :any, catalina:      "0ddf1b6ebd64e3989ee3e2c1482d3f852a3f44f6c196586d1d9c4e839927087a"
    sha256 cellar: :any, mojave:        "3d0291b16678836908fddc885fa613512e6f3ffbb2d11241a5320dfd48086822"
    sha256 cellar: :any, high_sierra:   "0b710c423d8895b711d3f658fa6abdffe2b351c2256a429f49363eece64b8928"
  end

  depends_on "gtk-doc" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gnt/gnt.h>

      int main() {
          gnt_init();
          gnt_quit();

          return 0;
      }
    EOS

    flags = [
      "-I#{Formula["glib"].opt_include}/glib-2.0",
      "-I#{Formula["glib"].opt_lib}/glib-2.0/include",
      "-I#{include}",
      "-L#{lib}",
      "-L#{Formula["glib"].opt_lib}",
      "-lgnt",
      "-lglib-2.0",
    ]
    system ENV.cc, "test.c", *flags, "-o", "test"
    system "./test"
  end
end
