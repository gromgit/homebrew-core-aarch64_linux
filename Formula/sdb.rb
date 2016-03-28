class Sdb < Formula
  desc "Ondisk/memory hashtable based on CDB."
  homepage "https://github.com/radare/sdb"
  url "http://www.radare.org/get/sdb-0.10.1.tar.gz"
  sha256 "dc17ce4bc6c2a5f2e63a404c3444d7ce4992c735e0ab04c93eb03ef8d965b3fa"

  bottle do
    cellar :any
    sha256 "a4d2903fb39d96ee2348ac1f5ee1fd09eab76cedbb47ffa2c76e66b03bfa4d58" => :el_capitan
    sha256 "bf924a465696ccb15322d4075f420d7d4cd2b710d13832bcd9cc287b80d1326f" => :yosemite
    sha256 "59f1108403e7a9f469235fe212feeef064735a712024496a1ed8b432eb130316" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "glib"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"sdb", testpath/"d", "hello=world"
    assert_equal "world", shell_output("#{bin}/sdb #{testpath}/d hello").strip
  end
end
