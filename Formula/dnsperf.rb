class Dnsperf < Formula
  desc "Measure DNS performance by simulating network conditions"
  homepage "https://www.dns-oarc.net/tools/dnsperf"
  url "https://www.dns-oarc.net/files/dnsperf/dnsperf-2.4.2.tar.gz"
  sha256 "be1782ada2bc735b1d3538ed2fa8fb52d917eb32538c2f0612ae60c024101c31"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?dnsperf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "ead688f57b8156c1b5462f2678af6e9ee82ca05d06863236fb08ae75d8bfac93"
    sha256 cellar: :any, big_sur:       "e0ce00cd550c6a1507a992838c63413c71638be2195d7a3f524fbc6cbaf802d0"
    sha256 cellar: :any, catalina:      "d0378a8c2eee660b95dcdba954aaf21eade2a0bd13e0a7ab71f2c4eca020884f"
    sha256 cellar: :any, mojave:        "49067cd216f02f9390bc4b7b790625122e23b7f411c8a8fc547694e79f1aaeff"
  end

  depends_on "pkg-config" => :build
  depends_on "bind"
  depends_on "krb5"
  depends_on "libxml2"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/dnsperf", "-h"
    system "#{bin}/resperf", "-h"
  end
end
