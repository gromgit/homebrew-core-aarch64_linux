class Gsoap < Formula
  desc "SOAP stub and skeleton compiler for C and C++"
  homepage "https://www.genivia.com/products.html"
  url "https://downloads.sourceforge.net/project/gsoap2/gsoap-2.8/gsoap_2.8.102.zip"
  sha256 "c7efad78caa4d41d1ec9762c1ac62a7e8d5a556c50c0b9d72b60cbd84aae6d10"

  bottle do
    sha256 "7149efee6569686649daa2c6be11a6ae15e949f8fcb7bfd63ef786902bd77a83" => :catalina
    sha256 "2d9af5d9fdc32c34085a009cc4504cf4512c4eee89ec4d02fee515b22003ec81" => :mojave
    sha256 "0c6ceb1f1ba06e6eb9417b8131daba88bc9cbe7918f756ecacde15e831eea892" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "openssl@1.1"

  uses_from_macos "bison"
  uses_from_macos "flex"
  uses_from_macos "zlib"

  def install
    # Contacted upstream by email and been told this should be fixed by 2.8.37,
    # it is due to the compilation of symbol2.c and soapcpp2_yacc.h not being
    # ordered correctly in parallel. However, issue persists as of 2.8.89.
    ENV.deparallelize
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/wsdl2h", "-o", "calc.h", "https://www.genivia.com/calc.wsdl"
    system "#{bin}/soapcpp2", "calc.h"
    assert_predicate testpath/"calc.add.req.xml", :exist?
  end
end
