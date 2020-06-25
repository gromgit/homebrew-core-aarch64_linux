class Profanity < Formula
  desc "Console based XMPP client"
  homepage "https://profanity-im.github.io"
  url "https://profanity-im.github.io/profanity-0.9.4.tar.gz"
  sha256 "661ce37ad28f5e4e204e28719403daba5330612f607c3d636050d69ad1d5901a"

  bottle do
    sha256 "89025daa50333c84810735579f831819c09a6e0043573fbcf82e13d150615ed8" => :catalina
    sha256 "c4bda058ebb6568e26d0919b9ee559d00b9aa5de98c895244cf8865500dd835b" => :mojave
    sha256 "9ef87a8a9fc4ea8a90c2fb669be002cb5c5f4d506dc28cb4cb799d7c671dc389" => :high_sierra
  end

  head do
    url "https://github.com/boothj5/profanity.git"

    depends_on "autoconf" => :build
    depends_on "autoconf-archive" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "gnutls"
  depends_on "gpgme"
  depends_on "libotr"
  depends_on "libsignal-protocol-c"
  depends_on "libstrophe"
  depends_on "openssl@1.1"
  depends_on "readline"
  depends_on "terminal-notifier"

  uses_from_macos "curl"

  def install
    system "./bootstrap.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/profanity", "-v"
  end
end
