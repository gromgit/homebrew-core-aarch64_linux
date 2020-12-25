class Htmldoc < Formula
  desc "Convert HTML to PDF or PostScript"
  homepage "https://www.msweet.org/htmldoc/"
  url "https://github.com/michaelrsweet/htmldoc/archive/v1.9.11.tar.gz"
  sha256 "eaa994270dc05ab52d57ed738128370ba783989e97687801fe3c12f445af0d05"
  license "GPL-2.0-only"
  head "https://github.com/michaelrsweet/htmldoc.git"

  bottle do
    sha256 "55c790b02ac59c49c70b8bec5d99ab5b364d44a40a348cbcb967f2c0c4eea3d8" => :big_sur
    sha256 "0f9e6dc5e68e5684dcd531ef1a134982f29b1d1c27ac35947543d36675fe8d6a" => :arm64_big_sur
    sha256 "d5845962e26e0e164f4dab3425bdd7391b3e01f3d0d19fba643f8bc8f24f17c4" => :catalina
    sha256 "6aef5c1eaf4e4b77b6383a17078048aab90a8efb3936fae7ba1f11591b7161af" => :mojave
  end

  depends_on "jpeg"
  depends_on "libpng"

  def install
    system "./configure", "--disable-debug",
                          "--disable-ssl",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/htmldoc", "--version"
  end
end
