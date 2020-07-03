class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/recursor.html"
  url "https://downloads.powerdns.com/releases/pdns-recursor-4.3.2.tar.bz2"
  sha256 "fcaeba94d5005ec3b973c1800d22eee686f785d3e635ad495d6f44067a4561e1"

  bottle do
    sha256 "7070944c3f1ff85a200f6010cd792ae0843f7c54e0e0e351f391876310ccdc7e" => :catalina
    sha256 "2db26f78466c6e0d08b1e2b3a09c124906b2a3a50c60bb2f574b0c346a427d34" => :mojave
    sha256 "b0ed864e0ce19f38919cf0b401ca2b0dc6a33889032278070c4e2cec30388162" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "gcc" if DevelopmentTools.clang_build_version == 600
  depends_on "lua"
  depends_on "openssl@1.1"

  def install
    ENV.cxx11

    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}/powerdns
      --disable-silent-rules
      --with-boost=#{Formula["boost"].opt_prefix}
      --with-libcrypto=#{Formula["openssl@1.1"].opt_prefix}
      --with-lua
      --without-net-snmp
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    output = shell_output("#{sbin}/pdns_recursor --version 2>&1")
    assert_match "PowerDNS Recursor #{version}", output
  end
end
