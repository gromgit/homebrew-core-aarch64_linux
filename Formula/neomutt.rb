class Neomutt < Formula
  desc "E-mail reader with support for Notmuch, NNTP and much more"
  homepage "https://neomutt.org/"
  url "https://github.com/neomutt/neomutt/archive/20200417.tar.gz"
  sha256 "6ed358053ae17694b580f3b5b13eec9f00f5a7320e76fae6fba767607c40cc48"
  head "https://github.com/neomutt/neomutt.git"

  bottle do
    rebuild 2
    sha256 "8b0809fb4ead2080bd19104687f4deb1d6c37385e4ccc209c5b8c100428c0a51" => :catalina
    sha256 "e08f68bbc3dce2c7e38e524d04fce1d0eba4d7808b58412883e38c0c2b2c8b60" => :mojave
    sha256 "cc63ec350ac050fdb97c52c4c4b15881d13fecb1fa31289ec0f946e97d9a0e80" => :high_sierra
  end

  depends_on "docbook-xsl" => :build
  depends_on "gettext"
  depends_on "gpgme"
  depends_on "libidn"
  depends_on "lmdb"
  depends_on "lua"
  depends_on "notmuch"
  depends_on "openssl@1.1"
  depends_on "tokyo-cabinet"

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    system "./configure", "--prefix=#{prefix}",
                          "--enable-gpgme",
                          "--with-gpgme=#{Formula["gpgme"].opt_prefix}",
                          "--gss",
                          "--lmdb",
                          "--notmuch",
                          "--sasl",
                          "--tokyocabinet",
                          "--with-ssl=#{Formula["openssl@1.1"].opt_prefix}",
                          "--with-ui=ncurses",
                          "--lua",
                          "--with-lua=#{Formula["lua"].prefix}"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/neomutt -F /dev/null -Q debug_level")
    assert_equal "set debug_level = 0", output.chomp
  end
end
