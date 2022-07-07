class Singular < Formula
  desc "Computer algebra system for polynomial computations"
  homepage "https://www.singular.uni-kl.de/"
  url "https://www.singular.uni-kl.de/ftp/pub/Math/Singular/SOURCES/4-3-1/singular-4.3.1p1.tar.gz"
  version "4.3.1p1"
  sha256 "1f1cba3ffd612b26d056859ca7f4cbeef5ce95cabd5782b035acd1c58ff01d30"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_monterey: "318d66e582a30a56b3174e2d951440ab97fa9258b3f45eb8a4ca2a15a6ae7a1e"
    sha256 arm64_big_sur:  "f23f081cc23770bf1e6552201c34d77962e59129fa8ac16ae1eea150fe5a8439"
    sha256 monterey:       "e2fe2989761b0d791ebedd0907db6dd53ce44056a1cda170bc83661410ef3563"
    sha256 big_sur:        "00997a197b4579071d8d9e6e11e70a28668ae760b7de5629ef671b7ad4a8e6bf"
    sha256 catalina:       "fc24449c1479823c71e7bbcf8debb4fbd69d32e8e9fef220fb6676ae0643f4b6"
    sha256 x86_64_linux:   "49b4654b7bb7aa4a26d5c7e81a5e9ec919664566de4d7c777e0a6f89128e5d35"
  end

  head do
    url "https://github.com/Singular/Singular.git", branch: "spielwiese"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "gmp"
  depends_on "mpfr"
  depends_on "ntl"
  depends_on "python@3.10"

  on_macos do
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    # Run autogen on macOS so that -flat_namespace flag is not used.
    system "./autogen.sh" if build.head? || OS.mac?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-python=#{Formula["python@3.10"].opt_bin}/python3",
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
