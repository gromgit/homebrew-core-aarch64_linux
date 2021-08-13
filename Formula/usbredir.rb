class Usbredir < Formula
  desc "USB traffic redirection library"
  homepage "https://www.spice-space.org"
  url "https://www.spice-space.org/download/usbredir/usbredir-0.11.0.tar.xz"
  sha256 "72dd5f3aa90dfbc0510b5149bb5b1654c8f21fdc405dfce7b5dc163dcff19cba"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.0-or-later"]

  livecheck do
    url "https://www.spice-space.org/download/usbredir/"
    regex(/href=.*?usbredir[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "6b3470eeeccaa4755b997102cee313d879e8b91df61c076ecbbc18c4fc572d47"
    sha256 cellar: :any, big_sur:       "26d2040e073333ad5e1aba9594f88c4450e7a9ee9780c8cc458267bea7e8c7c6"
    sha256 cellar: :any, catalina:      "1986f37f4c043ee0822fb0cc61049ab57a73871e94e3e64ad1896861be49890b"
    sha256 cellar: :any, mojave:        "04d2e58a8479304dba8f207283c5f740ea1a74440ecb3780aa4182025b268384"
    sha256               x86_64_linux:  "01398edf07804566c8b618707679e37d8ef1b485349ee7d4eccb8a7cb2613913"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libusb"

  def install
    system "meson", *std_meson_args, ".", "build"
    system "ninja", "-C", "build", "-v"
    system "ninja", "-C", "build", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <usbredirparser.h>
      int main() {
        return usbredirparser_create() ? 0 : 1;
      }
    EOS
    system ENV.cc, "test.c",
                   "-L#{lib}",
                   "-lusbredirparser",
                   "-o", "test"
    system "./test"
  end
end
