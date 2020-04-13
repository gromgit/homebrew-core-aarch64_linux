class Msmtp < Formula
  desc "SMTP client that can be used as an SMTP plugin for Mutt"
  homepage "https://marlam.de/msmtp/"
  url "https://marlam.de/msmtp/releases/msmtp-1.8.8.tar.xz"
  sha256 "eccb53e48f025f7e6f60210316df61cf6097a491728341c1e375fc1acc6459e5"

  bottle do
    sha256 "e742b036265028d00689e3476db274f47596ee6be299cb3f2f3f046d23d93741" => :catalina
    sha256 "902355fbdaa19cb16474403ed09babfdbf3072792ec525d43a9ba6fe719c761d" => :mojave
    sha256 "eab65ceebd178110b7857df4b6611b4ed8d7be0e030dbb3bd43a92502170d5a7" => :high_sierra
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
