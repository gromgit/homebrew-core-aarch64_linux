class Pdns < Formula
  desc "Authoritative nameserver"
  homepage "https://www.powerdns.com"
  url "https://downloads.powerdns.com/releases/pdns-4.6.3.tar.bz2"
  sha256 "acd06b89ca01d1adf61b906604614f0e1d77a1e94eeecade8ff5d53a16db7389"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "d89a331fc94f766564241fa2ea69af52ef1eb435ae72d2cceb4e2f86b58c8465"
    sha256 arm64_big_sur:  "72f70dd315d1f34fa08812de1553be73b40f7d3d973ee59e546c404e8bb13cdc"
    sha256 monterey:       "d1987783f1a072bacaff49f5b949ceaf9d3b679420bcc6f7aa071b4b00298e97"
    sha256 big_sur:        "30fea789a78aa1dfafc4a0668d17555744356e179fe860357434a2baf3de1b48"
    sha256 catalina:       "f26aa1bb33df99cb16a62106f537e57eb6fc6a2743ab0ea2ca1e15236fc541d2"
    sha256 x86_64_linux:   "4cae4548c14ac6bb2b9226280c552f51b63ce5da3b469dca02ec9f6f6e4a6a25"
  end

  head do
    url "https://github.com/powerdns/pdns.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool"  => :build
    depends_on "ragel"
  end

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "lua"
  depends_on "openssl@1.1"
  depends_on "sqlite"

  uses_from_macos "curl"

  fails_with gcc: "5" # for C++17

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}/powerdns
      --with-lua
      --with-libcrypto=#{Formula["openssl@1.1"].opt_prefix}
      --with-sqlite3
      --with-modules=gsqlite3
    ]

    system "./bootstrap" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  service do
    run opt_sbin/"pdns_server"
    keep_alive true
  end

  test do
    output = shell_output("#{sbin}/pdns_server --version 2>&1", 99)
    assert_match "PowerDNS Authoritative Server #{version}", output
  end
end
