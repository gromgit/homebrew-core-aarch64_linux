class Fragroute < Formula
  desc "Intercepts, modifies and rewrites egress traffic for a specified host"
  homepage "https://www.monkey.org/~dugsong/fragroute/"
  url "https://www.monkey.org/~dugsong/fragroute/fragroute-1.2.tar.gz"
  mirror "https://mirrorservice.org/sites/ftp.wiretapped.net/pub/security/packet-construction/fragroute-1.2.tar.gz"
  sha256 "6899a61ecacba3bb400a65b51b3c0f76d4e591dbf976fba0389434a29efc2003"
  license "BSD-3-Clause"
  revision 2

  livecheck do
    url :homepage
    regex(/href=.*?fragroute[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 "bc2aad3bd752e06ec939f1fd2f49ae26ceaff3175c6675be53c9dfebd41e694b" => :big_sur
    sha256 "4dc9241d550bf71ddf6dff241a3335bc2ee812415ac5e191887ae9ff2c91ae39" => :arm64_big_sur
    sha256 "7bd2a4a54f15b14b015e4defdfdf633db0b51cee12f126402dd99b708540ce9d" => :catalina
    sha256 "76571eb2b3a3026700b58e589b6a2e30651898763b63b26f9bc8d78856cf7e51" => :mojave
  end

  depends_on "libdnet"
  depends_on "libevent"

  uses_from_macos "libpcap"

  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/2f5cab626/fragroute/configure.patch"
    sha256 "215e21d92304e47239697945963c61445f961762aea38afec202e4dce4487557"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/2f5cab626/fragroute/fragroute.c.patch"
    sha256 "f4475dbe396ab873dcd78e3697db9d29315dcc4147fdbb22acb6391c0de011eb"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/2f5cab626/fragroute/pcaputil.c.patch"
    sha256 "c1036f61736289d3e9b9328fcb723dbe609453e5f2aab4875768068faade0391"
  end

  def install
    # pcaputil.h defines a "pcap_open()" helper function, but that name
    # conflicts with an unrelated function in newer versions of libpcap
    inreplace %w[pcaputil.h pcaputil.c tun-loop.c fragtest.c], /pcap_open\b/, "pcap_open_device_named"

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --mandir=#{man}
      --sysconfdir=#{etc}
      --with-libevent=#{Formula["libevent"].opt_prefix}
      --with-libdnet=#{Formula["libdnet"].opt_prefix}
    ]

    args << "--with-libpcap=#{MacOS.sdk_path}/usr" if !MacOS::CLT.installed? || MacOS.version != :sierra

    system "./configure", *args
    system "make", "install"
  end
end
