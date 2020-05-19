class Singular < Formula
  desc "Computer algebra system for polynomial computations"
  homepage "https://www.singular.uni-kl.de/"
  url "ftp://jim.mathematik.uni-kl.de/pub/Math/Singular/SOURCES/4-1-3/singular-4.1.3p2.tar.gz"
  version "4.1.3p2"
  sha256 "573f4ea5f526c6d80da3feef56362e0069e3b1a889f320ef9882996fbc857587"

  bottle do
    sha256 "a86e08a456bded36927341743e2f406620cba345956fe07cc9d5bb12e7a633bd" => :catalina
    sha256 "49fff6a1abc194a46f3b894ada49093c057d1c69a12180697a6c8dbff85777f5" => :mojave
    sha256 "5f7e0397c191718ca5be15495d5618ad5a071cc93bd933a516494d7fc3366087" => :high_sierra
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
