class Libxlsxwriter < Formula
  desc "C library for creating Excel XLSX files"
  homepage "https://libxlsxwriter.github.io/"
  url "https://github.com/jmcnamara/libxlsxwriter/archive/RELEASE_0.9.9.tar.gz"
  sha256 "bfb8c3bafc12a1191353152c51c75ce95741e7ee50a8ae4afbd8dd6b28c31e95"
  license "BSD-2-Clause"
  head "https://github.com/jmcnamara/libxlsxwriter.git"

  bottle do
    cellar :any
    sha256 "8d2be2c8af555c342b87fe53a9a0ee3465e88709060e836532d74dd5e51ed448" => :catalina
    sha256 "3e2efc2db62d07298f5d019c2b8590963373f792353608a609e0285fa96d9568" => :mojave
    sha256 "179efa56c5fb55d6be14c89fdfc5633778fc16410ab9d19359583df935035f43" => :high_sierra
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
