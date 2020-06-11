class Omega < Formula
  desc "Packaged search engine for websites, built on top of Xapian"
  homepage "https://xapian.org/"
  url "https://oligarchy.co.uk/xapian/1.4.16/xapian-omega-1.4.16.tar.xz"
  sha256 "b4fbeb9922d84af42ba80c0258cd07d103fd7f56c719f147049aa84598557694"

  bottle do
    sha256 "74c6765d98613554c318770837e011e15ddb3ac9c0ab89ea9daf5222cadfb442" => :catalina
    sha256 "b63722eb7af499fbf5a9d18000e73140f6e678f6b74b392ba211a28d9c927537" => :mojave
    sha256 "fea9fe989568f59aeedd52eb6b0c39c26cb15f01eeb1b3013a79e14c0dee7c1f" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libmagic"
  depends_on "pcre"
  depends_on "xapian"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/omindex", "--db", "./test", "--url", "/", "#{share}/doc/xapian-omega"
    assert_predicate testpath/"./test/flintlock", :exist?
  end
end
