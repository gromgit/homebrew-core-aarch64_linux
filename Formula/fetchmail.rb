class Fetchmail < Formula
  desc "Client for fetching mail from POP, IMAP, ETRN or ODMR-capable servers"
  homepage "https://www.fetchmail.info/"
  url "https://downloads.sourceforge.net/project/fetchmail/branch_6.4/fetchmail-6.4.14.tar.xz"
  sha256 "424707390f7cdc6d16db4887931117f2242873846b28cc1d0ae1c0ecf158bdcb"

  livecheck do
    url :stable
    regex(%r{url=.*?/branch_\d+(?:\.\d+)*?/fetchmail[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    cellar :any
    sha256 "4558e666d1df4bd8c580b6fc0bca771868cdd22011590f136dcfc967d02b263d" => :big_sur
    sha256 "b67dee738008d7bfec9676475bb0bded8cbe9224edc86356f240ebcc0051cac4" => :catalina
    sha256 "5ba114e574be07073607ee7788e60f7b75c5fd95f628b118e76b108689bd61d9" => :mojave
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
