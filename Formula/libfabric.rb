class Libfabric < Formula
  desc "OpenFabrics libfabric"
  homepage "https://ofiwg.github.io/libfabric/"
  url "https://github.com/ofiwg/libfabric/releases/download/v1.9.0/libfabric-1.9.0.tar.bz2"
  sha256 "559bfb7376c38253c936d0b104591c3394880376d676894895706c4f5f88597c"
  head "https://github.com/ofiwg/libfabric.git"

  bottle do
    cellar :any
    sha256 "f862553dea1aa4f6916cf36094d4ffcd8a1c1d0760d5718c5081564dea3f7785" => :catalina
    sha256 "20b2f7cacbf9aa9278d293d36f8b921ce47be662fc945b23ed0183181f933486" => :mojave
    sha256 "28b788cdf0c97f4b583c907ffa29b1a52862fff0987ad2279b773c07fde7f322" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool"  => :build

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#(bin}/fi_info"
  end
end
