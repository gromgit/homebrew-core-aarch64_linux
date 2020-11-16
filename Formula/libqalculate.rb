class Libqalculate < Formula
  desc "Library for Qalculate! program"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/libqalculate/releases/download/v3.14.0/libqalculate-3.14.0.tar.gz"
  sha256 "ef422aa54eac7c711ece65dd3a5cbc66370d3e17173465313201897c201e7d3e"
  license "GPL-2.0-or-later"

  bottle do
    sha256 "0f46816cae6ec126d635b287d1a36eb6a60d44aee1664dc5093ba61d6a13535d" => :big_sur
    sha256 "b53f2a3209c4344749769c0879ad83ddbd5df78c71168b0c91388a219a98d0aa" => :catalina
    sha256 "e18d4fc0159ed4f7311366363c564d7e5e5a7aa877db40cac8d0bd4cbf775c61" => :mojave
    sha256 "6829bd3b47962411998cdf443605702745ebfd614b6bf0da7439217daa1660de" => :high_sierra
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
