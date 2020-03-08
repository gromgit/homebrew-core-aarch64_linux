class Ipmiutil < Formula
  desc "IPMI server management utility"
  homepage "https://ipmiutil.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ipmiutil/ipmiutil-3.1.5.tar.gz"
  sha256 "58ccdbd5755d7dd72478756715af09e9c73330dfad2b91dbf03d2ac504b301a3"

  bottle do
    cellar :any_skip_relocation
    sha256 "e2ea930b55754e8e0b27b675ebabdf2c12a73ddd0c8d994484c8b7e351350ec5" => :catalina
    sha256 "c1d4a86dae7aae9e8ce807741c42e91884156eda9b9004ab2f151e2cfda6b74d" => :mojave
    sha256 "9e4ae6d909010bcff31df4fcef39a9cb0de2083aded6b960483db942c9e18f0f" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl@1.1"

  conflicts_with "renameutils", :because => "both install `icmd` binaries"

  def install
    # Darwin does not exist only on PowerPC
    inreplace "configure.ac", "test \"$archp\" = \"powerpc\"", "true"
    system "autoreconf", "-fiv"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-sha256",
                          "--enable-gpl"

    system "make", "TMPDIR=#{ENV["TMPDIR"]}"
    # DESTDIR is needed to make everything go where we want it.
    system "make", "prefix=/",
                   "DESTDIR=#{prefix}",
                   "varto=#{var}/lib/#{name}",
                   "initto=#{etc}/init.d",
                   "sysdto=#{prefix}/#{name}",
                   "install"
  end

  test do
    system "#{bin}/ipmiutil", "delloem", "help"
  end
end
