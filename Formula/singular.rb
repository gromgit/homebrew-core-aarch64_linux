class Singular < Formula
  desc "Computer algebra system for polynomial computations"
  homepage "https://www.singular.uni-kl.de/"
  url "ftp://jim.mathematik.uni-kl.de/pub/Math/Singular/SOURCES/4-1-3/singular-4.1.3p2.tar.gz"
  version "4.1.3p2"
  sha256 "573f4ea5f526c6d80da3feef56362e0069e3b1a889f320ef9882996fbc857587"

  bottle do
    sha256 "cfae6f7caed42457b53162e4b8bb1ad2bb6fed62eeaf0ebe010a6078ed648553" => :catalina
    sha256 "a1ef3230103e83b912220afbd87d055174c0261857068498cb3ea85598523ea8" => :mojave
    sha256 "bbc3ef698536d7f5d3beb0be0daf667d71e6257b6a290b6ac3b1a6008b2ab6c7" => :high_sierra
  end

  head do
    url "https://github.com/Singular/Sources.git", :branch => "spielwiese"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "gmp"
  depends_on "mpfr"
  depends_on "ntl"
  depends_on "python@3.8"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-python=#{Formula["python@3.8"].opt_bin}/python3",
                          "CXXFLAGS=-std=c++11"
    system "make", "install"
  end

  test do
    testinput = <<~EOS
      ring r = 0,(x,y,z),dp;
      poly p = x;
      poly q = y;
      poly qq = z;
      p*q*qq;
    EOS
    assert_match "xyz", pipe_output("#{bin}/Singular", testinput, 0)
  end
end
