class Libofx < Formula
  desc "Library to support OFX command responses"
  homepage "https://libofx.sourceforge.io"
  url "https://downloads.sourceforge.net/project/libofx/libofx/libofx-0.9.15.tar.gz"
  sha256 "e95c14e09fc37b331af3ef4ef7bea29eb8564a06982959fbd4bca7e331816144"

  bottle do
    rebuild 1
    sha256 "95cee3bf5da4fcb5eaeb73a4970632d2786b0f12b3b97a0e919c4d29336d8c08" => :catalina
    sha256 "f04974342f8b883cb1248e27ff12dfd347d5e6c201852ed0d816ed4852c5be86" => :mojave
    sha256 "591595de707127624906cafcb8d1271a6d907f4a3cbe2311c93bff53a969937a" => :high_sierra
  end

  depends_on "open-sp"

  def install
    opensp = Formula["open-sp"]
    system "./configure", "--disable-dependency-tracking",
                          "--with-opensp-includes=#{opensp.opt_include}/OpenSP",
                          "--with-opensp-libs=#{opensp.opt_lib}",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "ofxdump #{version}", shell_output("#{bin}/ofxdump -V").chomp
  end
end
