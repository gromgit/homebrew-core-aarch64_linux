class Gtksourceviewmm < Formula
  desc "C++ bindings for gtksourceview"
  homepage "https://developer.gnome.org/gtksourceviewmm/"
  url "https://download.gnome.org/sources/gtksourceviewmm/2.10/gtksourceviewmm-2.10.3.tar.xz"
  sha256 "0000df1b582d7be2e412020c5d748f21c0e6e5074c6b2ca8529985e70479375b"
  license "LGPL-2.1-or-later"
  revision 10

  livecheck do
    url :stable
    regex(/gtksourceviewmm[._-]v?(2\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "8accd4b62e2a81b42a17acfbae054e81e8c25a9c02c5223c52d1890290731219" => :big_sur
    sha256 "b18df29fc3f1e2b0458530ca9132da65ede64c461411021dfbfcc2c81d0d231b" => :catalina
    sha256 "7922e406c8d456752fdab0dce85355adcaa024bc26b9376c5fbf32820789df0c" => :mojave
  end

  depends_on "pkg-config" => [:build, :test]
  depends_on "gtkmm"
  depends_on "gtksourceview"

  def install
    ENV.cxx11
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <gtksourceviewmm.h>

      int main(int argc, char *argv[]) {
        gtksourceview::init();
        return 0;
      }
    EOS
    ENV.libxml2
    command = "#{Formula["pkg-config"].opt_bin}/pkg-config --cflags --libs gtksourceviewmm-2.0"
    flags = shell_output(command).strip.split
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
