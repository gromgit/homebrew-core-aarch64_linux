class Fetchmail < Formula
  desc "Fetch mail from a POP, IMAP, ETRN, or ODMR-capable server"
  homepage "https://www.fetchmail.info/"
  url "https://downloads.sourceforge.net/project/fetchmail/branch_6.4/fetchmail-6.4.6.tar.xz"
  sha256 "16efec4b6019b4d2b6e43ed1d4f523dee019ac86754de856d0cf34d503d66011"

  bottle do
    cellar :any
    sha256 "b400dc2710440539698edb114e13f4b1fac9c2a4b538049de73abf9f2fee4bba" => :catalina
    sha256 "50674a1a4cd1ef3f28d6ef40d206af1b1a44cc8c76e561612c7d1da582a87312" => :mojave
    sha256 "586ab565a1defb1ac0c3ee38dee5e6af96fd1dcb9f955f017a4c48448c13bf53" => :high_sierra
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
