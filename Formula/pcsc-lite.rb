class PcscLite < Formula
  desc "Middleware to access a smart card using SCard API"
  homepage "https://pcsclite.apdu.fr/"
  url "https://pcsclite.apdu.fr/files/pcsc-lite-1.9.0.tar.bz2"
  sha256 "0148d403137124552c5d0f10f8cdab2cbb8dfc7c6ce75e018faf667be34f2ef9"

  bottle do
    cellar :any
    sha256 "91abf052e57e7318c312280b2d7561f7086d2b408182d05040181b61ad76ab82" => :catalina
    sha256 "0ee727a04ea8be3f4997d7fbb3d6f904136ab1430b468ee0ca237f82f13db338" => :mojave
    sha256 "60fc7ec0222710dc894afb838e7c63942c5106a88d812dfaac19c112de9e6b0f" => :high_sierra
  end

  keg_only :shadowed_by_macos, "macOS provides PCSC.framework"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--disable-libsystemd"
    system "make", "install"
  end

  test do
    system sbin/"pcscd", "--version"
  end
end
