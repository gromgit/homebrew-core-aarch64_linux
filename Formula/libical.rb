class Libical < Formula
  desc "Implementation of iCalendar protocols and data formats"
  homepage "https://libical.github.io/libical/"
  url "https://github.com/libical/libical/archive/v3.0.7.tar.gz"
  sha256 "546115fe53dc8800e79478211efa5c2cfe7cae8e34cff54fbc14b42cd98e4fe5"

  bottle do
    cellar :any
    sha256 "71bd098bc73c1dbd57d0453dd297e71cbb9b9400ef4680a6cf5ed3e622a9e897" => :catalina
    sha256 "5a59126f6b2a6fc0febc7dc71cb72e09d4e7c789eaee3502aa38ac3ee4b3ca4f" => :mojave
    sha256 "dceec75d740489e95eb73088cb8de2fc9dd080d6ea4a88844ad06fa2d980668e" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "icu4c"
  uses_from_macos "libxml2"

  def install
    system "cmake", ".", "-DBDB_LIBRARY=BDB_LIBRARY-NOTFOUND",
                         "-DENABLE_GTK_DOC=OFF",
                         "-DSHARED_ONLY=ON",
                         *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #define LIBICAL_GLIB_UNSTABLE_API 1
      #include <libical-glib/libical-glib.h>
      int main(int argc, char *argv[]) {
        ICalParser *parser = i_cal_parser_new();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-lical-glib",
                   "-I#{Formula["glib"].opt_include}/glib-2.0",
                   "-I#{Formula["glib"].opt_lib}/glib-2.0/include"
    system "./test"
  end
end
