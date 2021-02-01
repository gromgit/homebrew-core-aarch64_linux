class Inadyn < Formula
  desc "Dynamic DNS client with IPv4, IPv6, and SSL/TLS support"
  homepage "https://troglobit.com/projects/inadyn/"
  url "https://github.com/troglobit/inadyn/releases/download/v2.8.1/inadyn-2.8.1.tar.xz"
  sha256 "1185a9fb165bfc5f5b5f66f0dd8a695c9bd78d4b20cd162273eeea77f2d2e685"
  license all_of: ["GPL-2.0-or-later", "ISC", "MIT"]

  bottle do
    sha256 big_sur: "7f9d314798a94e4e49a16350e70557de633fe42ff47e9fcfcf9c3e4054932c3c"
    sha256 arm64_big_sur: "2cbabfe7c86d67e99218fd34afd49f97cf7f9a164f383072d50c8d95f343fd9a"
    sha256 catalina: "29c03eaf67c3ca7d75ddbdee20c8875156d014f37f1f81afa5e4718dc2349167"
    sha256 mojave: "0408849a9bdec78ccb0e503d2db0a6d4b9b0110f02a1b5c05c082351d07eff97"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake"    => :build
  depends_on "libtool"  => :build
  depends_on "confuse"
  depends_on "gnutls"
  depends_on "pkg-config"

  def install
    mkdir_p buildpath/"inadyn/m4"
    system "autoreconf", "-vif"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}"
    system "make", "install"
  end

  test do
    system "#{sbin}/inadyn", "--check-config", "--config=#{HOMEBREW_PREFIX}/share/doc/inadyn/examples/inadyn.conf"
  end
end
