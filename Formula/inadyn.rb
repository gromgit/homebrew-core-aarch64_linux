class Inadyn < Formula
  desc "Dynamic DNS client with IPv4, IPv6, and SSL/TLS support"
  homepage "https://troglobit.com/projects/inadyn/"
  url "https://github.com/troglobit/inadyn/releases/download/v2.7/inadyn-2.7.tar.xz"
  sha256 "eb03bc9d9c09dfbbc651b43a2eb5a967d0454a8293576df23784710dac50c6a4"

  bottle do
    sha256 "51a4e9ac812bcef5def36bce74489e54bba0e2c671491c738a41c42c6f7c4918" => :catalina
    sha256 "850595bc38129a1301b47e285b826ba578f301ae285a5fbf2239c41334d54bba" => :mojave
    sha256 "863dc8ee816ca82fb165c3919ea9b0fd564648a745e3525d46043318f5c93723" => :high_sierra
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
