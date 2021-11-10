class Msmtp < Formula
  desc "SMTP client that can be used as an SMTP plugin for Mutt"
  homepage "https://marlam.de/msmtp/"
  url "https://marlam.de/msmtp/releases/msmtp-1.8.19.tar.xz"
  sha256 "34a1e1981176874dbe4ee66ee0d9103c90989aa4dcdc4861e4de05ce7e44526b"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://marlam.de/msmtp/download/"
    regex(/href=.*?msmtp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "4bbe3d7e3d0517d3773a511854d0132793a83744f03add396641703b5a0b70d0"
    sha256 arm64_big_sur:  "b808aa8faa33fd35f611594e650a9b5ec993aeb579d1bae81dc1d72bca9ffff3"
    sha256 monterey:       "2fdd667a38138fa440d9aab3357676865fa9f15ba91e3cbe030eac754d100433"
    sha256 big_sur:        "6ee5aa8e7d52373b8249f9d1e34203beead0cc86163d96dac1854bc6648945ec"
    sha256 catalina:       "28a120b2fda2c50a4efe60367b5fdd9a4e936f46b1adffb422499c3e610d17ac"
    sha256 x86_64_linux:   "8337630534e09069a6ca50f4006f564058424f37ea3a4e4977c2a7b61dad184c"
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gnutls"
  depends_on "libidn2"

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules", "--with-macosx-keyring"
    system "make", "install"
    (pkgshare/"scripts").install "scripts/msmtpq"
  end

  test do
    system bin/"msmtp", "--help"
  end
end
