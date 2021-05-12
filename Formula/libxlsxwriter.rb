class Libxlsxwriter < Formula
  desc "C library for creating Excel XLSX files"
  homepage "https://libxlsxwriter.github.io/"
  url "https://github.com/jmcnamara/libxlsxwriter/archive/RELEASE_1.0.4.tar.gz"
  sha256 "d1c8179ecebd3f216aa4bb4fab8618dea0ac74fe8bd7272e67abf51c12becebb"
  license "BSD-2-Clause"
  head "https://github.com/jmcnamara/libxlsxwriter.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "bb575a5b82fd00811f534f7fd37151a5bcd4139db768392fd0130a240693e9fb"
    sha256 cellar: :any, big_sur:       "f71344d98629d7886eda2496750445758d501355bd66b7d8456173e363668318"
    sha256 cellar: :any, catalina:      "eca0465e6edc3d46c2a89f69bb2581993af10718576b0895b2a54f40dc06ad12"
    sha256 cellar: :any, mojave:        "b3e64fb9013e6cbffa9e5f5f20e7adc743ad063e521a3a6972423deef7059ede"
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
