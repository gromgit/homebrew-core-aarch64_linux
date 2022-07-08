class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/recursor.html"
  url "https://downloads.powerdns.com/releases/pdns-recursor-4.7.1.tar.bz2"
  sha256 "d2f94573a6f0e63a1034ca2b301c27ebf2e1300a655ba669cc502d5ea8d6ec68"
  license "GPL-2.0-only"

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns-recursor[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "8efb58d8c7628b7809f291d845ed51a40000d4745311170055e534e92da7fd7e"
    sha256 arm64_big_sur:  "f1f7f552470d269544bf110dffa130caa10865fff6446fa266e1d94da8909045"
    sha256 monterey:       "96923e8aee1975168cb39d06bf347560abaf805f83d8aa23680a79a4263b0fe3"
    sha256 big_sur:        "85b0213089276ed9ea234a94ad5b535563288dee6ea3aba67d62b198b0223d47"
    sha256 catalina:       "61c5e0449aa3dc557a0ff7613bbb524a4590c1bd959fc5b4a9c9180e45e9f50d"
    sha256 x86_64_linux:   "6513aed54812ba8fb1da94e42aae3febc1271e7135223b10dd0a7d9bc7bf92b3"
  end

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "lua"
  depends_on "openssl@3"

  on_macos do
    # This shouldn't be needed for `:test`, but there's a bug in `brew`:
    # CompilerSelectionError: pdnsrec cannot be built with any available compilers.
    depends_on "llvm" => [:build, :test] if DevelopmentTools.clang_build_version <= 1100
  end

  on_linux do
    depends_on "gcc"
  end

  fails_with :clang do
    build 1100
    cause <<-EOS
      Undefined symbols for architecture x86_64:
        "MOADNSParser::init(bool, std::__1::basic_string_view<char, std::__1::char_traits<char> > const&)"
    EOS
  end

  fails_with gcc: "5"

  def install
    ENV.cxx11
    ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1100)

    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}/powerdns
      --disable-silent-rules
      --with-boost=#{Formula["boost"].opt_prefix}
      --with-libcrypto=#{Formula["openssl@3"].opt_prefix}
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
