class NetSnmp < Formula
  desc "Implements SNMP v1, v2c, and v3, using IPv4 and IPv6"
  homepage "http://www.net-snmp.org/"
  url "https://downloads.sourceforge.net/project/net-snmp/net-snmp/5.9/net-snmp-5.9.tar.gz"
  sha256 "04303a66f85d6d8b16d3cc53bde50428877c82ab524e17591dfceaeb94df6071"
  license "Net-SNMP"
  head "https://github.com/net-snmp/net-snmp.git"
  # ...previously used "https://git.code.sf.net/p/net-snmp/code" but github seems more current

  livecheck do
    url :stable
    regex(%r{url=.*?/net-snmp[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 "46837a0296f9a9cb434371d7377800da0e0e06a09ef07a0d70bd79d8bbe3bfb2" => :catalina
    sha256 "57dc4d78d02ec37a30d822b40aca17afc187de70c15d87c62bd660c5cc17d211" => :mojave
    sha256 "8285c2dfee4c083c7ea0f5c99964aaa68c5cc26e4c223405727ec9fc85d636db" => :high_sierra
  end

  keg_only :provided_by_macos

  depends_on "openssl@1.1"

  # Fix "make install" bug with 5.9
  patch do
    url "https://github.com/net-snmp/net-snmp/commit/52d4a465dcd92db004c34c1ad6a86fe36726e61b.patch?full_index=1"
    sha256 "669185758aa3a4815f4bbbe533795c4b6969c0c80c573f8c8abfa86911c57492"
  end

  # Clean up some Xcode 12 issues with ./configure
  patch do
    url "https://github.com/net-snmp/net-snmp/commit/a7c8c26c48c954a19bca5fdc6ba285396610d7aa.patch?full_index=1"
    sha256 "8ccc46a3c15d145e5034c0749f3c0e7bd11eca451809ae7f2312dab459e07cec"
  end

  def install
    # Workaround https://github.com/net-snmp/net-snmp/issues/226 in 5.9:
    inreplace "agent/mibgroup/mibII/icmp.h", "darwin10", "darwin"

    args = %W[
      --disable-debugging
      --prefix=#{prefix}
      --enable-ipv6
      --with-defaults
      --with-persistent-directory=#{var}/db/net-snmp
      --with-logfile=#{var}/log/snmpd.log
      --with-mib-modules=host\ ucd-snmp/diskio
      --without-rpm
      --without-kmem-usage
      --disable-embedded-perl
      --without-perl-modules
      --with-openssl=#{Formula["openssl@1.1"].opt_prefix}
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  def post_install
    (var/"db/net-snmp").mkpath
    (var/"log").mkpath
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snmpwalk -V 2>&1")
  end
end
