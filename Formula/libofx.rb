class Libofx < Formula
  desc "Library to support OFX command responses"
  homepage "https://libofx.sourceforge.io"
  url "https://downloads.sourceforge.net/project/libofx/libofx/libofx-0.9.15.tar.gz"
  sha256 "e95c14e09fc37b331af3ef4ef7bea29eb8564a06982959fbd4bca7e331816144"
  license "GPL-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/libofx[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    rebuild 1
    sha256 "1a79a86dec4941045cc078ac6f43b401972eb4a07b7ae72593e4972b3c2ba631" => :big_sur
    sha256 "9d047abebed9d7c5554b6b853e256d4385152ecf67cc7109710140f988502a48" => :arm64_big_sur
    sha256 "b10f735c4f3ac6359e776ba83622d89baa52ad422e2159e94d40e6d2c10a0fc5" => :catalina
    sha256 "4b16fe23cf0cd2bc44db7e4816b04e3217742bec7ce0bba75fe8fa45754be28f" => :mojave
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
