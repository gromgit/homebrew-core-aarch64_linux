class Gsoap < Formula
  desc "SOAP stub and skeleton compiler for C and C++"
  homepage "https://www.genivia.com/products.html"
  url "https://downloads.sourceforge.net/project/gsoap2/gsoap-2.8/gsoap_2.8.111.zip"
  sha256 "f1670c7e3aeaa66bc5658539fbd162e5099f022666855ef2b2c2bac07fec4bd3"
  license any_of: ["GPL-2.0-or-later", "gSOAP-1.3b"]

  livecheck do
    url :stable
    regex(%r{url=.*?/gsoap[._-]v?(\d+(?:\.\d+)+)\.zip}i)
  end

  bottle do
    sha256 "c55587438262b398d433af85087de4ebc8f90b43cb797f0677f386d8506680d5" => :big_sur
    sha256 "786cd2fafa7aecc09f78f5282372d77043b7c6203d5d565f58459f63dc2ef7f0" => :arm64_big_sur
    sha256 "d961088f83353a43f77ce55fd0986e1402ecfe47626d06b73cc654b346b4a758" => :catalina
    sha256 "2c76abc3cfdae87a6193e5de6dc0cb06c41affce2bf11b3284effca70f8c7ada" => :mojave
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
