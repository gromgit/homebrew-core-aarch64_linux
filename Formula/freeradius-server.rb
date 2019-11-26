class FreeradiusServer < Formula
  desc "High-performance and highly configurable RADIUS server"
  homepage "https://freeradius.org/"
  url "https://github.com/FreeRADIUS/freeradius-server/archive/release_3_0_20.tar.gz"
  sha256 "8177fe550af6685a040884dbe3df28431bdc5a8d3a48a9f4f88bdb49f2d0e90c"
  head "https://github.com/FreeRADIUS/freeradius-server.git"

  bottle do
    sha256 "eeec4733e5c9daba6a384600b7ef95dab513e5f4c744ea62eb9b608599b29e6b" => :catalina
    sha256 "7a2a426654c18300d324d10937d239815cd98f7ff0cc14ee559989556336898e" => :mojave
    sha256 "db3eff9b15d53109b5fb41c39ffecb27191733e1deaba62e17ec21bb249aab31" => :high_sierra
    sha256 "c2ff882edd53c1644843e29b23cc11b160dea126be8016925514fc34976b4f58" => :sierra
  end

  depends_on "openssl@1.1"
  depends_on "talloc"
  uses_from_macos "perl"

  def install
    ENV.deparallelize

    args = %W[
      --prefix=#{prefix}
      --sbindir=#{bin}
      --localstatedir=#{var}
      --with-openssl-includes=#{Formula["openssl@1.1"].opt_include}
      --with-openssl-libraries=#{Formula["openssl@1.1"].opt_lib}
      --with-talloc-lib-dir=#{Formula["talloc"].opt_lib}
      --with-talloc-include-dir=#{Formula["talloc"].opt_include}
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  def post_install
    (var/"run/radiusd").mkpath
    (var/"log/radius").mkpath
  end

  test do
    output = shell_output("#{bin}/smbencrypt homebrew")
    assert_match "77C8009C912CFFCF3832C92FC614B7D1", output
  end
end
