class Msmtp < Formula
  desc "SMTP client that can be used as an SMTP plugin for Mutt"
  homepage "https://marlam.de/msmtp/"
  url "https://marlam.de/msmtp/releases/msmtp-1.8.14.tar.xz"
  sha256 "d56f065d711486e9c234618515a02a48a48dab4051b34f3e108fbecb6fb773b4"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://marlam.de/msmtp/download/"
    regex(/href=.*?msmtp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 "6aaafd49ab1aaa27f1fca16cfdb7f997bbc07d266060e4a4a89745d9f292703c" => :big_sur
    sha256 "948e097324e1469fbd84f7a936072e1bd0dcf4da9ba8cad4c1a04097f23916c2" => :catalina
    sha256 "aa8cc81aa72d795102d3030ac5a4e941df350f6bc6524cc30fee8f60076745e8" => :mojave
  end

  depends_on "pkg-config" => :build
  depends_on "gnutls"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --with-macosx-keyring
      --prefix=#{prefix}
    ]

    system "./configure", *args
    system "make", "install"
    (pkgshare/"scripts").install "scripts/msmtpq"
  end

  test do
    system bin/"msmtp", "--help"
  end
end
