class Whois < Formula
  desc "Lookup tool for domain names and other internet resources"
  homepage "https://packages.debian.org/sid/whois"
  url "https://deb.debian.org/debian/pool/main/w/whois/whois_5.5.6.tar.xz"
  sha256 "cba1e9000c60950f46a96ba23e8eea8aee240a2b8560e63a6bfb33f9034af14e"
  license "GPL-2.0-or-later"
  head "https://github.com/rfc1036/whois.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "4c80af702b8cdc7538f9ee8691c778be40dcf54b921e90335e170dc3abb9c188" => :catalina
    sha256 "6abbe4e3371272f0fc49261885b9a131913809173acf0c2bdc11f6dbd818741d" => :mojave
    sha256 "501fa1f4c2909514fa4c80d5af3a2f47d88ccdb7ad978925735849f0f7d804c3" => :high_sierra
  end

  keg_only :provided_by_macos

  depends_on "pkg-config" => :build
  depends_on "libidn2"

  def install
    ENV.append "LDFLAGS", "-L/usr/lib -liconv"

    system "make", "whois", "HAVE_ICONV=1"
    bin.install "whois"
    man1.install "whois.1"
    man5.install "whois.conf.5"
  end

  test do
    system "#{bin}/whois", "brew.sh"
  end
end
