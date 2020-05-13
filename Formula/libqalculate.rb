class Libqalculate < Formula
  desc "Library for Qalculate! program"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/libqalculate/releases/download/v3.10.0/libqalculate-3.10.0.tar.gz"
  sha256 "c203ffb1926e2cfd94714b9c3d270d53eddd85d57565d3829bb9ee7407b196db"

  bottle do
    sha256 "0390862bb3d859dbf626e805c142cad96137e314fb18cb0a963c74161c553a86" => :catalina
    sha256 "fe19330e391bf5b17ea420c7440403dfa680cc55dcef4e4272c7202910ace180" => :mojave
    sha256 "fee382fcd0c446a6f50e0147fdc5c47542f3cab7c975b2b7268d6a67e1389b09" => :high_sierra
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gnuplot"
  depends_on "mpfr"
  depends_on "readline"

  def install
    ENV.cxx11
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--without-icu",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/qalc", "-nocurrencies", "(2+2)/4 hours to minutes"
  end
end
