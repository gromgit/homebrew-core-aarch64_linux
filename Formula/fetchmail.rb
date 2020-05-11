class Fetchmail < Formula
  desc "Fetch mail from a POP, IMAP, ETRN, or ODMR-capable server"
  homepage "https://www.fetchmail.info/"
  url "https://downloads.sourceforge.net/project/fetchmail/branch_6.4/fetchmail-6.4.5.tar.xz"
  sha256 "d30f06920294490141ddcd4a66583bf16a0c88c1d7b4f58a3b9cef8511946b1c"

  bottle do
    cellar :any
    sha256 "c9a5dfab8c291541e7e1277c7c4309dbbb1e73e8b818e5a653b4b18d62d50bab" => :catalina
    sha256 "d1c2dc3133e47b621d6b6c60ca384c7fb446020042ec56f38511f23e2fe348a4" => :mojave
    sha256 "e0753454244c267f79cfe5a2f7ec98ed6e5a5db497432545ca47ae67fce1b62a" => :high_sierra
  end

  depends_on "openssl@1.1"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-ssl=#{Formula["openssl@1.1"].opt_prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/fetchmail", "--version"
  end
end
