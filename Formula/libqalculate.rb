class Libqalculate < Formula
  desc "Library for Qalculate! program"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/libqalculate/releases/download/v3.9.0/libqalculate-3.9.0.tar.gz"
  sha256 "d9d219e74314f863811763be0518f05362dc0b084222728786d8639fadce37dd"

  bottle do
    sha256 "23539612692e41e90179cfe64513663cd6b55cb989e8163e7f5353f093c11700" => :catalina
    sha256 "b87485d1e8a6684744d2a527750dc5360f7839b6ba399fbf7fbe8ebf0ed3d077" => :mojave
    sha256 "ba2dd1969dd3cc4aa2d0cfb04dee0ca770135212188cfd8fac6ad7859e681565" => :high_sierra
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
