class Deheader < Formula
  desc "Analyze C/C++ files for unnecessary headers"
  homepage "http://www.catb.org/~esr/deheader"
  url "http://www.catb.org/~esr/deheader/deheader-1.7.tar.gz"
  sha256 "6856e4fa3efa664a0444b81c2e1f0209103be3b058455625c79abe65cf8db70d"
  license "BSD-2-Clause"
  head "https://gitlab.com/esr/deheader.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "84bb08cf8c454272c7bfa95f530dc8f8bc15af43748631704dc7321f2989226c" => :catalina
    sha256 "cef55345cf5a32b30aa7d9a320b3143eb05b5f8329a8abbfad2a247622ab233f" => :mojave
    sha256 "cf2689471e033bb6e55cd948679eef30c9abecb17f022fc6cb914fbe0ca85c6d" => :high_sierra
    sha256 "2b70a9eb18042a3e93ab8fc1bf018c417d8b41f9b8efe6d818d45aed6922cf52" => :sierra
    sha256 "2b70a9eb18042a3e93ab8fc1bf018c417d8b41f9b8efe6d818d45aed6922cf52" => :el_capitan
    sha256 "2b70a9eb18042a3e93ab8fc1bf018c417d8b41f9b8efe6d818d45aed6922cf52" => :yosemite
  end

  depends_on "xmlto" => :build

  on_linux do
    depends_on "libarchive" => :build
  end

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    system "make"
    bin.install "deheader"
    man1.install "deheader.1"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <string.h>
      int main(void) {
        printf("%s", "foo");
        return 0;
      }
    EOS
    assert_equal "121", shell_output("#{bin}/deheader test.c | tr -cd 0-9")
  end
end
