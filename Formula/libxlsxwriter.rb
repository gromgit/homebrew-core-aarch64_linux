class Libxlsxwriter < Formula
  desc "C library for creating Excel XLSX files"
  homepage "https://libxlsxwriter.github.io/"
  url "https://github.com/jmcnamara/libxlsxwriter/archive/RELEASE_0.9.8.tar.gz"
  sha256 "7147d67cfb3dc99f1b2af5ced2c21ce164911c28d9185a1654200dd199f00ace"
  license "BSD-2-Clause"
  head "https://github.com/jmcnamara/libxlsxwriter.git"

  bottle do
    cellar :any
    sha256 "049e11b6dc6d7b08f7afaa3a786884afa0d4b6ca08ec83e8096712b26a050d9b" => :catalina
    sha256 "ea49ea81391a74d9b470b6995816aaaaa7bdeb1e489847a24fb48f6ab8b972b3" => :mojave
    sha256 "1b49ed8af2c976c84adeca4d6e806ac5f0f189f5932d940dab01f3130650a1c2" => :high_sierra
  end

  uses_from_macos "zlib"

  def install
    system "make", "install", "PREFIX=#{prefix}", "V=1"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "xlsxwriter.h"

      int main() {
          lxw_workbook  *workbook  = workbook_new("myexcel.xlsx");
          lxw_worksheet *worksheet = workbook_add_worksheet(workbook, NULL);
          int row = 0;
          int col = 0;

          worksheet_write_string(worksheet, row, col, "Hello me!", NULL);

          return workbook_close(workbook);
      }
    EOS

    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}", "-lxlsxwriter", "-o", "test"
    system "./test"
    assert_predicate testpath/"myexcel.xlsx", :exist?, "Failed to create xlsx file"
  end
end
