class Libxo < Formula
  desc "Allows an application to generate text, XML, JSON, and HTML output"
  homepage "https://juniper.github.io/libxo/libxo-manual.html"
  url "https://github.com/Juniper/libxo/releases/download/1.5.0/libxo-1.5.0.tar.gz"
  sha256 "b2ed5a23a5d70750114ecdc109e2a76d6c674453ef265bff22f80ae81a84fa8c"
  license "BSD-2-Clause"

  bottle do
    sha256 arm64_big_sur: "46b68b40babcce388ba53e357fc204b7ca9077882703328eaa3caa0298a3247f"
    sha256 big_sur:       "4c3d730c8da43b89a8e7b322d0093f6a8c1d557800278620dd086d022e0ddeb5"
    sha256 catalina:      "f238413de8067d4a86ddd0e784d033f42effd96f041ac48f97bd1d1e40c55737"
    sha256 mojave:        "9c8f3a24ae3b83cb1d2b9db171fa83e0d9a77415bed8f4930f7d31a7a506e25d"
  end

  depends_on "libtool" => :build

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libxo/xo.h>
      int main() {
        xo_set_flags(NULL, XOF_KEYS);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lxo", "-o", "test"
    system "./test"
  end
end
