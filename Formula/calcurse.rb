class Calcurse < Formula
  desc "Text-based personal organizer"
  homepage "https://calcurse.org/"
  url "https://calcurse.org/files/calcurse-4.7.0.tar.gz"
  sha256 "ef6675966a53f41196006ce624ece222fe400da0563f4fed1ae0272ad45c8435"
  license "BSD-2-Clause"
  head "https://git.calcurse.org/calcurse.git"

  bottle do
    sha256 "21cb64443bbffe19f0adb8dfc8f5e49eabed5fc5c0347215bbb7aa3383126719" => :catalina
    sha256 "0d114c613163c192e9f156750ffa9c3c9a4a303c103a7bc7091c369da151a4c4" => :mojave
    sha256 "41886cc820da1133c6c5f57fea4f9fbe072a0735e3ef8522a9301736216f4e70" => :high_sierra
  end

  depends_on "gettext"

  if build.head?
    depends_on "asciidoc" => :build
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    system "./autogen.sh" if build.head?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    # Specify XML_CATALOG_FILES for asciidoc
    system "make", "XML_CATALOG_FILES=/usr/local/etc/xml/catalog"
    system "make", "install"
  end

  test do
    system bin/"calcurse", "-v"
  end
end
