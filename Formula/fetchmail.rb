class Fetchmail < Formula
  desc "Client for fetching mail from POP, IMAP, ETRN or ODMR-capable servers"
  homepage "https://www.fetchmail.info/"
  url "https://downloads.sourceforge.net/project/fetchmail/branch_6.4/fetchmail-6.4.13.tar.xz"
  sha256 "7d28cf060b06b9c8ec72267be7edc9a99b70f61d7d32d8b609458dcedfa74be1"

  livecheck do
    url :stable
    regex(%r{url=.*?/branch_\d+(?:\.\d+)*?/fetchmail[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    cellar :any
    sha256 "ddfe9fb2f887e126a342d328f15e1e605dc4e3a010de8ecd2f8c87c6ec9f41c6" => :catalina
    sha256 "acf99e4e026b233c26d45d0b6eb902aaf2fd94fef8ad88681dabb14531bd9391" => :mojave
    sha256 "c934824791e311a5a18f442a41822338d6a1ef5446d4bc52bbf9b7319991a1b2" => :high_sierra
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
