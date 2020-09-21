class X3270 < Formula
  desc "IBM 3270 terminal emulator for the X Window System and Windows"
  homepage "http://x3270.bgp.nu/"
  url "http://x3270.bgp.nu/download/04.00/suite3270-4.0ga11-src.tgz"
  sha256 "48cf5966e52439b829c9d074e209b351572e0083cf81eba855336908c2c77f6c"
  license "BSD-3-Clause"

  livecheck do
    url "http://x3270.bgp.nu/download.html"
    regex(/href=.*?suite3270[._-]v?(\d+(?:\.\d+)+(?:ga\d+)?)(?:-src)?\.t/i)
  end

  bottle do
    sha256 "1207876192b9bd7bcf06c7811cb376426e47028027a47718dc32224972352e80" => :catalina
    sha256 "d2d31ed1a62515d6acd00b2d3fa72a821b1d94bb13b581830e30664fe72f2626" => :mojave
    sha256 "c68394dce8fc34be49786ebfd1c0beb914b1f894611fc97163ca5a3097967151" => :high_sierra
  end

  depends_on "readline"

  def install
    args = %W[
      --prefix=#{prefix}
      --enable-c3270
      --enable-pr3287
      --enable-s3270
      --enable-tcl3270
    ]

    system "./configure", *args
    system "make", "install"
    system "make", "install.man"
  end

  test do
    system bin/"c3270", "--version"
  end
end
