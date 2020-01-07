class Silk < Formula
  desc "Collection of traffic analysis tools"
  homepage "https://tools.netsa.cert.org/silk/"
  url "https://tools.netsa.cert.org/releases/silk-3.19.0.tar.gz"
  sha256 "0f5bdcf437a1dc0429a5acb48b8e9ef18050999a230920369c05b2db9f020695"

  bottle do
    sha256 "5248ab37b8ab6b5f4af1247b336a010fa7903a9aa26cc5bcc2fc3186ca1e3313" => :catalina
    sha256 "bede7abfbd61702f7bf34f57fb15ffc179c59e8224aaad8e2caa2a25582a8b96" => :mojave
    sha256 "90a46c1d80f214041df14dc7d8b680901a9bf181292164bf231bd1959f3214e7" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libfixbuf"
  depends_on "yaf"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --mandir=#{man}
      --enable-ipv6
      --enable-data-rootdir=#{var}/silk
    ]

    system "./configure", *args
    system "make"
    system "make", "install"

    (var/"silk").mkpath
  end

  test do
    input = test_fixtures("test.pcap")
    output = shell_output("yaf --in #{input} | #{bin}/rwipfix2silk | #{bin}/rwcount --no-titles --no-column")
    assert_equal "2014/10/02T10:29:00|2.00|1031.00|12.00|", output.strip
  end
end
