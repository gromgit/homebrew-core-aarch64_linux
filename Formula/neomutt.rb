class Neomutt < Formula
  desc "E-mail reader with support for Notmuch, NNTP and much more"
  homepage "https://neomutt.org/"
  url "https://github.com/neomutt/neomutt/archive/20200417.tar.gz"
  sha256 "6ed358053ae17694b580f3b5b13eec9f00f5a7320e76fae6fba767607c40cc48"
  head "https://github.com/neomutt/neomutt.git"

  bottle do
    sha256 "af6a0dfa14c50a67f1b41d9221ac54086574e363fe01337d29708560ac038e43" => :catalina
    sha256 "106dcf1f1357e7a11bcbcdb0a138c5f263720bdfa8f11a4528c56632c0fc5372" => :mojave
    sha256 "2199a7a481944e7d5404320d84736318f1577a1d8a0ebefcf7630c6f3ba967f5" => :high_sierra
  end

  depends_on "docbook-xsl" => :build
  depends_on "gettext"
  depends_on "gpgme"
  depends_on "libidn"
  depends_on "lmdb"
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
                          "--with-ui=ncurses"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/neomutt -F /dev/null -Q debug_level")
    assert_equal "set debug_level = 0", output.chomp
  end
end
