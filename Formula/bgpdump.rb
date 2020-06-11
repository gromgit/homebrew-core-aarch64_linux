class Bgpdump < Formula
  desc "C library for analyzing MRT/Zebra/Quagga dump files"
  homepage "https://github.com/RIPE-NCC/bgpdump/wiki"
  url "https://github.com/RIPE-NCC/bgpdump/archive/v1.6.2.tar.gz"
  sha256 "415692c173a84c48b1e927a6423a4f8fd3e6359bc3008c06b7702fe143a76223"

  bottle do
    cellar :any
    sha256 "7e50f91444d64c2b76ce16391a879d0afe678456cd2f619d506134c4d7d35834" => :catalina
    sha256 "406ef291f4a600d418b7af2e2c70abaf2a752c63ed77e7f787897631d5ebfa92" => :mojave
    sha256 "7348bfb1fa936eea53b0790002c67edd75831f6754b2fa5b3120ceb76df70a51" => :high_sierra
  end

  depends_on "autoconf" => :build

  def install
    system "./bootstrap.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/bgpdump", "-T"
  end
end
