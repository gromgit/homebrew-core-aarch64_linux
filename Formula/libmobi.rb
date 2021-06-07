class Libmobi < Formula
  desc "C library for handling Kindle (MOBI) formats of ebook documents"
  homepage "https://github.com/bfabiszewski/libmobi/"
  url "https://github.com/bfabiszewski/libmobi/releases/download/v0.6/libmobi-0.6.tar.gz"
  sha256 "c35bd44279575bf8b102d23eba482805bfc1e5a49df8414d851507e8ea811c5d"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "c5278432f0d13b9e7df78a64f94f554fd8a18810e109a62b556e1ee135c5e9c7"
    sha256 cellar: :any, big_sur:       "09fcc2ffd8033d5406a770484b0dc6c18fec71a67264c77ad4f93af4302c8697"
    sha256 cellar: :any, catalina:      "dda06a2599862e896c17decedb77f6d2a3dae354c4b17fe33ab21ff242a7b73c"
    sha256 cellar: :any, mojave:        "aa60c60d6d6443b2a5a80ac507c554576f601ff06dd069577b7be89ab3a17f34"
  end

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <mobi.h>
      int main() {
        MOBIData *m = mobi_init();
        if (m == NULL) {
          return 1;
        }
        mobi_free(m);
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-L#{lib}", "-lmobi", "-o", "test"
    system "./test"
  end
end
