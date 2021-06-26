class Healpix < Formula
  desc "Hierarchical Equal Area isoLatitude Pixelization of a sphere"
  homepage "https://healpix.jpl.nasa.gov"
  url "https://downloads.sourceforge.net/project/healpix/Healpix_3.80/Healpix_3.80_2021Jun22.tar.gz"
  version "3.80"
  sha256 "8de4aabaa3d55e0c63a62c621bfd77298732c6b75782016217f5659143acbcf5"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "ce666045edcf27ed989c24f5a8079e5bc8b06b50e2e6f8b805ea71dd842fc1f3"
    sha256 cellar: :any, big_sur:       "29e7c43a550369e045676034878acd1b977ed18a28a6f1bd33bd1405fc2e385d"
    sha256 cellar: :any, catalina:      "59fd161e08ea1758ed4bbc524d8f9008954ea6bb8e38131b7834ca36e719a9f5"
    sha256 cellar: :any, mojave:        "dd732e1a1d931be08b90dd7ba7676d77a929b1f431a1a937ab4d91a32d52c4cf"
    sha256 cellar: :any, high_sierra:   "f18787c3cf20536ee93762580b2537318da0601fd9cde0f28295363b59ee8a0a"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "cfitsio"

  def install
    configure_args = %w[
      --disable-dependency-tracking
      --disable-silent-rules
    ]

    cd "src/C/autotools" do
      system "autoreconf", "--install"
      system "./configure", "--prefix=#{prefix}", *configure_args
      system "make", "install"
    end

    cd "src/common_libraries/libsharp" do
      system "./configure", "--prefix=#{prefix}", *configure_args
      system "make", "install"
    end

    cd "src/cxx" do
      ENV["SHARP_CFLAGS"] = "-I#{include}"
      ENV["SHARP_LIBS"] = "-L#{lib} -lsharp"
      system "./configure", "--prefix=#{prefix}", *configure_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cxx").write <<-EOS
      #include <math.h>
      #include <stdio.h>
      #include "chealpix.h"
      int main(void) {
        long nside, npix, pp, ns1;
        nside = 1024;
        for (pp = 0; pp < 14; pp++) {
          nside = pow(2, pp);
          npix = nside2npix(nside);
          ns1  = npix2nside(npix);
        }
      };
    EOS

    system ENV.cxx, "-o", "test", "test.cxx", "-L#{lib}", "-lchealpix"
    system "./test"
  end
end
