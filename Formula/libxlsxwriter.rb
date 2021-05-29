class Libxlsxwriter < Formula
  desc "C library for creating Excel XLSX files"
  homepage "https://libxlsxwriter.github.io/"
  url "https://github.com/jmcnamara/libxlsxwriter/archive/RELEASE_1.0.6.tar.gz"
  sha256 "6217d2940a44c2eac3b48942e83e1320a871e47aabdb4047484426539e45e930"
  license "BSD-2-Clause"
  head "https://github.com/jmcnamara/libxlsxwriter.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "42462d3f09c3f2f707a617a924bfee067ab3a9e84ed448dadc6274f22b039e6f"
    sha256 cellar: :any, big_sur:       "dcec722f917471d3e44aeb8b09f5b59c48e381a4645deac16f659a5d996b7478"
    sha256 cellar: :any, catalina:      "683b07013452995c4e8d9e88e3ba4d98b9b17e9613edbc4b57072eb2363e9075"
    sha256 cellar: :any, mojave:        "c416cf82aa6d06fba5c782299f98995615ed54f013dea89c66319c9787b224f7"
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
