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
    sha256 "8b5a87b7cae2d578e00075136ceccaca0c29dbcbb1b01e15675bc29b9205e93d" => :catalina
    sha256 "49f91a2616ef97ae98f005907b63d6a76e25ac32c9efff8f277d16742b7b971c" => :mojave
    sha256 "3392e2a1e9a8631c45d4ddcd16284d8ab5cac2dc3f71783688db50183ad414b6" => :high_sierra
    sha256 "cc8ca43ae5c45a8821a8a4803e4aca6e316a1b0c2083adb6cdc539acce3cfbbe" => :sierra
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

    args << "--with-libpcap=#{MacOS.sdk_path}/usr" unless MacOS::CLT.installed? && MacOS.version == :sierra

    system "./configure", *args
    system "make", "install"
  end
end
