class Libxlsxwriter < Formula
  desc "C library for creating Excel XLSX files"
  homepage "https://libxlsxwriter.github.io/"
  url "https://github.com/jmcnamara/libxlsxwriter/archive/RELEASE_1.1.0.tar.gz"
  sha256 "c74e6bed66158aaf86b2d624243c6d89cdbbbca406258ab5ef0d55e71381773e"
  license "BSD-2-Clause"
  head "https://github.com/jmcnamara/libxlsxwriter.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "ec4a6553cc3b8bb943e6aff112ae72a0193b084a692392ab5f5f338a0ac2b1c1"
    sha256 cellar: :any,                 big_sur:       "592f47fa0014617db7fae12faac2d82a9f20898dd125f8593f1738200d0aa4a0"
    sha256 cellar: :any,                 catalina:      "ce346ff9b7e67d9f5adf1e14b29d0c1196a055f5f67b7b1959791492366f7482"
    sha256 cellar: :any,                 mojave:        "81b4f4602a9bdee2318f9bee55629979d5f48802d0c35cca32b96908a8a6e334"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c3e5a5df2443c869974231d45674a7a8ddc21ed2efa9824888624c1eae1f8dc"
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
