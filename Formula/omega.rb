class Omega < Formula
  desc "Packaged search engine for websites, built on top of Xapian"
  homepage "https://xapian.org/"
  url "https://oligarchy.co.uk/xapian/1.4.17/xapian-omega-1.4.17.tar.xz"
  sha256 "d52eea4cd1bbf334e84af6d41ea3424466ab75e3dadd4a736e4eb0c976392d16"
  license "GPL-2.0"

  bottle do
    sha256 "d87aa45d8872c68c3d9eb1d02a080680dc2161bab3b5fe41a2d17e5f114b6c8c" => :big_sur
    sha256 "21def29541640883bd956e842a3370d9ac7dde45bd166add19ca83013f86189f" => :catalina
    sha256 "5625e477813a8c7bd720e17416b6dd80faf959f5d7210c3262031ba30c3e1f6e" => :mojave
    sha256 "ff44c076ce6ad71238f2293e35ad7c8fed610dfeb5eb15e8a52c0e68d9a0b62d" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libmagic"
  depends_on "pcre"
  depends_on "xapian"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/omindex", "--db", "./test", "--url", "/", "#{share}/doc/xapian-omega"
    assert_predicate testpath/"./test/flintlock", :exist?
  end
end
