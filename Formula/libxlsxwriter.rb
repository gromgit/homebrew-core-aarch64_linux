class Libxlsxwriter < Formula
  desc "C library for creating Excel XLSX files"
  homepage "https://libxlsxwriter.github.io/"
  url "https://github.com/jmcnamara/libxlsxwriter/archive/RELEASE_1.0.3.tar.gz"
  sha256 "ff373664af1fc3821f934a05275d668f3f0e20663fddebeaa89fcb9a9d52b80d"
  license "BSD-2-Clause"
  head "https://github.com/jmcnamara/libxlsxwriter.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "c504e489fb9f0a9725dc246be23c0c11483c0beaeed7cfa6dad4ffb59cafe360"
    sha256 cellar: :any, big_sur:       "8aba1d59b8d63026a9e587b7becb2633f59d59d684ac0bfe0731aaefd237beb4"
    sha256 cellar: :any, catalina:      "9a8481e6efebacd41ded5114168bddd860393648c561629afda73d79d2445c99"
    sha256 cellar: :any, mojave:        "1af82ea2c703b4ffe8deaca1d5263769b6550891239a07c24ac47b9c3c397271"
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
