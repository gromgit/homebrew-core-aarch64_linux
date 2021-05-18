class SstpClient < Formula
  desc "SSTP (Microsofts Remote Access Solution for PPP over SSL) client"
  homepage "https://sstp-client.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/sstp-client/sstp-client/sstp-client-1.0.15.tar.gz"
  sha256 "8484aa51fbfbe418a0ebad58ad20a8ee1c46ed71f800be18bcd23b42e6baad64"
  license "GPL-2.0-or-later"
  version_scheme 1

  livecheck do
    url :stable
    regex(%r{url=.*?/sstp-client[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_big_sur: "c0d8c3b433fbd9ece940977305d962542a5b5548d7798884fb375eeabd735cb9"
    sha256 big_sur:       "923965f4053281aed44dbf377dbbe624b31e38da8f9302370f178d735d8e6eb4"
    sha256 catalina:      "a51a6b4290efdecd167fcbdc4dc481fb4c1aeff00f280d4ca747158dbc2b5d47"
    sha256 mojave:        "ea8342928439b65db7face3b6e2291e5e8405714b87f461523834ef2d0b7fba5"
  end

  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on "openssl@1.1"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--disable-ppp-plugin",
                          "--prefix=#{prefix}",
                          "--with-runtime-dir=#{var}/run/sstpc"
    system "make", "install"

    # Create a directory needed by sstpc for privilege separation
    (var/"run/sstpc").mkpath
  end

  def caveats
    <<~EOS
      sstpc reads PPP configuration options from /etc/ppp/options. If this file
      does not exist yet, type the following command to create it:

      sudo touch /etc/ppp/options
    EOS
  end

  test do
    system "#{sbin}/sstpc", "--version"
  end
end
