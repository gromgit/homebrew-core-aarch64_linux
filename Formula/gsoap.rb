class Gsoap < Formula
  desc "SOAP stub and skeleton compiler for C and C++"
  homepage "https://www.genivia.com/products.html"
  url "https://downloads.sourceforge.net/project/gsoap2/gsoap-2.8/gsoap_2.8.104.zip"
  sha256 "60fcd137c59a7640470f873d9a0a29c62896a15e8517a2f5a03eb2d7eebc0c52"

  bottle do
    sha256 "6721742878f94c04756d18ca5d4555d43cfbae6d33add3a1afb4c0f20c0c3684" => :catalina
    sha256 "a6c9a0b6057e9117b678a0f9232d33f88770cf838365fbdbc628b7d9fc92b8bb" => :mojave
    sha256 "0baeffa7065bfafc8572ff3bb23cd85cf82b49aa1fe9f25f3b02171d1f1100dc" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "openssl@1.1"

  uses_from_macos "bison"
  uses_from_macos "flex"
  uses_from_macos "zlib"

  def install
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
