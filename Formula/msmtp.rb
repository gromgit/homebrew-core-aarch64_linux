class Msmtp < Formula
  desc "SMTP client that can be used as an SMTP plugin for Mutt"
  homepage "https://marlam.de/msmtp/"
  url "https://marlam.de/msmtp/releases/msmtp-1.8.17.tar.xz"
  sha256 "0fddbe74c1a9dcf6461b4a1b0db3e4d34266184500c403d7f107ad42db4ec4d3"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://marlam.de/msmtp/download/"
    regex(/href=.*?msmtp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "e3c002f51aad6d5fbe7b63a403c85c4f03357fb9e888b107adc07ebe26b91e88"
    sha256 big_sur:       "6c263b2417be9fa52e5dd3e191e0ebc01700d1c84a0e1aee74e8627d2bb8667c"
    sha256 catalina:      "517ec9746a322fccbea429fb43665eb89f8495f65c1c355ca92ca582bf5aea49"
    sha256 mojave:        "d11af3fb5a135e6f7cd14a680c4cd9e9df021c88321bc3ae7dddb48711340406"
    sha256 x86_64_linux:  "8560c7eaed75bbc84f3bd6533864155fdce07e95c3b948663316df3dd5c13d98"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gnutls"
  depends_on "libidn2"

  # Patch is needed on top of 1.8.17 to fix build on macOS.
  # Remove in next release. Build dependencies autoconf and automake can also
  # be removed in next release, as well as the autoreconf call in the install block.
  # See https://github.com/marlam/mpop-mirror/issues/9#issuecomment-941099714
  patch do
    url "https://git.marlam.de/gitweb/?p=msmtp.git;a=patch;h=7f03f3767ee6b7311621386c77cb5575fcaa13d0"
    sha256 "5896a6ec4f12e8c2c56c957974448778bcdf1308654564cdc5672dac642400c3"
  end

  def install
    system "autoreconf", "-ivf"
    system "./configure", *std_configure_args, "--disable-silent-rules", "--with-macosx-keyring"
    system "make", "install"
    (pkgshare/"scripts").install "scripts/msmtpq"
  end

  test do
    system bin/"msmtp", "--help"
  end
end
