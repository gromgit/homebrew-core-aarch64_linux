class Gloox < Formula
  desc "C++ Jabber/XMPP library that handles the low-level protocol"
  homepage "https://camaya.net/gloox/"
  url "https://camaya.net/download/gloox-1.0.23.tar.bz2"
  sha256 "97cb6a0c07e320ffa4a7c66e8ab06b2361086271dc87ed2398befef4e8435f8a"

  bottle do
    cellar :any
    sha256 "e47784efba1f772b982a2cc8456469c87f5ee42988b294d14b701cfcb9bcd1b6" => :catalina
    sha256 "4d7f5c002dc74b477a069fae22b7361371fa692a378a4186a508a92ecf24e7ad" => :mojave
    sha256 "53776432ab6f6637983b846f853a922fbe71e2d370f58457dc35eab30f3737bc" => :high_sierra
    sha256 "906216cebdc6ae1bf7e5f1a6eae8ae60fd5747f6832288a652f68a480d6dd42d" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libidn"
  depends_on "openssl@1.1"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-zlib",
                          "--disable-debug",
                          "--with-openssl=#{Formula["openssl@1.1"].opt_prefix}"
    system "make", "install"
  end

  test do
    system bin/"gloox-config", "--cflags", "--libs", "--version"
  end
end
