class Ginac < Formula
  desc "Not a Computer algebra system"
  homepage "https://www.ginac.de/"
  url "https://www.ginac.de/ginac-1.7.9.tar.bz2"
  sha256 "67cdff43a4360da997ee5323cce27cf313a5b17ba58f02e8f886138c0f629821"

  bottle do
    cellar :any
    sha256 "17ebe7f3dc2e2a8cd837f3ddbc4ec5640eac827e08f883e791547d00d311e24b" => :catalina
    sha256 "922e03357f99e4355f697a6ca5f2d92da81f90b8fb51db3214cbde83f5288d0c" => :mojave
    sha256 "d40b7e0f950c8e793061231d37b153932e91353222d1976a7c663f4ce5863886" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "cln"
  depends_on "python@3.8"
  depends_on "readline"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <ginac/ginac.h>
      using namespace std;
      using namespace GiNaC;

      int main() {
        symbol x("x"), y("y");
        ex poly;

        for (int i=0; i<3; ++i) {
          poly += factorial(i+16)*pow(x,i)*pow(y,2-i);
        }

        cout << poly << endl;
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}",
                                "-L#{Formula["cln"].lib}",
                                "-lcln", "-lginac", "-o", "test",
                                "-std=c++11"
    system "./test"
  end
end
