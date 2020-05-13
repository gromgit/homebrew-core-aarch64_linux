class ClawsMail < Formula
  desc "The user-friendly, lightweight, and fast email client"
  homepage "https://www.claws-mail.org/"
  url "https://www.claws-mail.org/releases/claws-mail-3.17.5.tar.gz"
  sha256 "f79e4c7f089d08e6b2b3323a90b6f46991a154ce168ba4a829d593b7a5768c7b"
  revision 1

  bottle do
    sha256 "4bcd9ef99cb4d5bae16955d0e233bdb7587dd9e4d752a157ff4becd76f7c6c10" => :catalina
    sha256 "a9e585254e35406a81cedec91987b99df7f3ca5fcc0e5275fddb057fd7029199" => :mojave
    sha256 "5c95e783f0a6af22de1dce7a268c891733fda3b8e49e0c0c6a86ba2c3149fab1" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "glib"
  depends_on "gnutls"
  depends_on "gtk+"
  depends_on "libetpan"
  depends_on "nettle"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "LDFLAGS=-Wl,-framework -Wl,Security",
                          "--disable-archive-plugin",
                          "--disable-dillo-plugin",
                          "--disable-notification-plugin"
    system "make", "install"
  end

  test do
    assert_equal ".claws-mail", shell_output("#{bin}/claws-mail --config-dir").strip
  end
end
