class PgpoolIi < Formula
  desc "PostgreSQL connection pool server"
  homepage "https://www.pgpool.net/mediawiki/index.php/Main_Page"
  url "https://www.pgpool.net/mediawiki/images/pgpool-II-4.2.1.tar.gz"
  sha256 "98938af9fccc37bcea76e6422e42ce003faedb1186cdc3b9940eb6ba948cdae1"

  livecheck do
    url "https://www.pgpool.net/mediawiki/index.php/Downloads"
    regex(/href=.*?pgpool-II[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 "5d9e9684a6889d139033d02927823fe34f23c8feb12b06f4570cf5028bc84d2d" => :big_sur
    sha256 "7b0245d2cfad6fdb47a8ae12a2c8f787cf917ae521244a42e9bdf79254f492f8" => :catalina
    sha256 "9847e3f4dfb8351c0e2d0e855b4cb3bd5beb0ea2d3237c544b82a150d0aacfeb" => :mojave
  end

  depends_on "postgresql"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"
    system "make", "install"
  end

  test do
    cp etc/"pgpool.conf.sample", testpath/"pgpool.conf"
    system bin/"pg_md5", "--md5auth", "pool_passwd", "--config-file", "pgpool.conf"
  end
end
