class Gtksourceviewmm3 < Formula
  desc "C++ bindings for gtksourceview3"
  homepage "https://developer.gnome.org/gtksourceviewmm/"
  url "https://download.gnome.org/sources/gtksourceviewmm/3.18/gtksourceviewmm-3.18.0.tar.xz"
  sha256 "51081ae3d37975dae33d3f6a40621d85cb68f4b36ae3835eec1513482aacfb39"
  license "LGPL-2.1-or-later"
  revision 9

  livecheck do
    url :stable
    regex(/gtksourceviewmm[._-]v?(3\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "410f481ec74d576858da9c468fbf49b065513f1aebd4096f7316ba71b8338a75" => :big_sur
    sha256 "51fb7575fc5e1b1cd5449fc3197a0a3d6ee60531d75996d4c2ed008e024b37c5" => :catalina
    sha256 "e311753b64f695584ec760e8509a6a18c1a11d1aa708b59f727df889d53caf6b" => :mojave
  end

  depends_on "pkg-config" => [:build, :test]
  depends_on "gtkmm3"
  depends_on "gtksourceview3"

  def install
    ENV.cxx11
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <gtksourceviewmm.h>

      int main(int argc, char *argv[]) {
        Gsv::init();
        return 0;
      }
    EOS
    ENV.libxml2
    command = "#{Formula["pkg-config"].opt_bin}/pkg-config --cflags --libs gtksourceviewmm-3.0"
    flags = shell_output(command).strip.split
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
