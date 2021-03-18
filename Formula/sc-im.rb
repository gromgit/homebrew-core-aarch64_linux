class ScIm < Formula
  desc "Spreadsheet program for the terminal, using ncurses"
  homepage "https://github.com/andmarti1424/sc-im"
  url "https://github.com/andmarti1424/sc-im/archive/v0.8.0.tar.gz"
  sha256 "ba65b3936a21ae65b19d99a4cfbb69bb57d8b00880f0781fb620e8857bc498db"
  license "BSD-4-Clause"
  head "https://github.com/andmarti1424/sc-im.git", branch: "freeze"

  bottle do
    sha256 arm64_big_sur: "f7ad6c86caf94bf75c40da5422ac4eeaef52e7c5b6065f32981dec2c54bef5c9"
    sha256 big_sur:       "d419452946bad457347ca8c59b3d53a90f3976af74d1e652de8e1ad4d0982f9a"
    sha256 catalina:      "24cb0ad706b03a9933cdb24dba862b38a3fcb59f96f9942227d8f9f79ff93ea5"
    sha256 mojave:        "67180ab11eedd56f8eaffb0d2f12a90ca9636bbd93ff693914450be8248702ce"
    sha256 high_sierra:   "275a0a9dbd1a1271119e36b2767a54587aae57a65ee92278e701e0e1236a192c"
    sha256 sierra:        "f346970ef805cec01ae6485365d8fb5002533255c01e81bdd44d072058d00081"
    sha256 el_capitan:    "50e8d50e0373ac626ad617057eb1246c779e1e3b05171f4be2aa547c5b8ddf4c"
  end

  depends_on "ncurses"

  def install
    cd "src" do
      system "make", "prefix=#{prefix}"
      system "make", "prefix=#{prefix}", "install"
    end
  end

  test do
    input = <<~EOS
      let A1=1+1
      getnum A1
    EOS
    output = pipe_output(
      "#{bin}/sc-im --nocurses --quit_afterload 2>/dev/null", input
    )
    assert_equal "2", output.lines.last.chomp
  end
end
