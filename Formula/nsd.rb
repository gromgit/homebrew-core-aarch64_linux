class Nsd < Formula
  desc "Name server daemon"
  homepage "https://www.nlnetlabs.nl/projects/nsd/"
  url "https://www.nlnetlabs.nl/downloads/nsd/nsd-4.3.2.tar.gz"
  sha256 "5b5cee2f80ed451f19e02dee620c71a98a781bd72a55810e0acc925fecaa8329"
  license "BSD-3-Clause"

  bottle do
    sha256 "69f6d9d52527c392e5d01ec67d78b71113a799e3ce02e15837e8e947f0509c81" => :catalina
    sha256 "f6f707defe682c1e7f5d477166f5adae5687bfb5ff25895ece916be1674ba5d0" => :mojave
    sha256 "e9780a88833916958fa7f276efe27d792b996d64a988f5684acd8c2c336eba50" => :high_sierra
  end

  depends_on "libevent"
  depends_on "openssl@1.1"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}",
                          "--with-libevent=#{Formula["libevent"].opt_prefix}",
                          "--with-ssl=#{Formula["openssl@1.1"].opt_prefix}"
    system "make", "install"
  end

  test do
    system "#{sbin}/nsd", "-v"
  end
end
