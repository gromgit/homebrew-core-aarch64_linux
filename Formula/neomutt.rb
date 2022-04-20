class Neomutt < Formula
  desc "E-mail reader with support for Notmuch, NNTP and much more"
  homepage "https://neomutt.org/"
  url "https://github.com/neomutt/neomutt/archive/20220415.tar.gz"
  sha256 "84982cb4c2fed63e90d71fab45faa90738bfc58050430606135cbd8924d94682"
  license "GPL-2.0-or-later"
  head "https://github.com/neomutt/neomutt.git", branch: "main"

  bottle do
    sha256 arm64_monterey: "ca5c8221b3701ff99cb8f382bfb46eb14a935e6bd1d5da89a9add25f9b612b66"
    sha256 arm64_big_sur:  "e5908c743fe353d2895b5ff08a2d7a73b36866ab8d581aab590ec018dfa560e3"
    sha256 monterey:       "cbd8b897bcc0d90f81d3d751cf2457cca095ca3de9b495ba05c2d69b62ee88e0"
    sha256 big_sur:        "37dea01682e93e6df780f1cbf71988a8280e062f9daaa56c61e38bb188107a5d"
    sha256 catalina:       "f4e344cf43f5d561f8c8d2d0f2a95470369b68a26bec68dda191bc34d02838cf"
    sha256 x86_64_linux:   "e6e3b82efcb82e7e60748a064954665b712fc2c73503ff39f7d13f36d0fd5c59"
  end

  depends_on "docbook-xsl" => :build
  depends_on "gettext"
  depends_on "gpgme"
  depends_on "libidn2"
  depends_on "lmdb"
  depends_on "lua"
  depends_on "ncurses"
  depends_on "notmuch"
  depends_on "openssl@1.1"
  depends_on "tokyo-cabinet"

  uses_from_macos "libxslt" => :build # for xsltproc
  uses_from_macos "cyrus-sasl"
  uses_from_macos "krb5"
  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    args = %W[
      --prefix=#{prefix}
      --gss
      --disable-idn
      --idn2
      --lmdb
      --notmuch
      --sasl
      --tokyocabinet
      --with-gpgme=#{Formula["gpgme"].opt_prefix}
      --with-lua=#{Formula["lua"].opt_prefix}
      --with-ssl=#{Formula["openssl@1.1"].opt_prefix}
      --with-ui=ncurses
    ]

    args << "--pkgconf" if OS.linux?

    system "./configure", *args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/neomutt -F /dev/null -Q debug_level")
    assert_equal "set debug_level = 0", output.chomp
  end
end
