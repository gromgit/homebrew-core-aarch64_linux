class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https://www.freetds.org/"
  url "https://www.freetds.org/files/stable/freetds-1.1.40.tar.gz"
  sha256 "79e0492b9c689ad63d8039ec5a7e0dd3cbeced74e6c80d4df7050e5fa6a0f64f"

  bottle do
    sha256 "31adb48d4b25dad80ca1bb6b4fd270526f0a5a86daf62b6c602e8df8a7967747" => :catalina
    sha256 "54e37b355b2fb63faa6d0bfa17277d9c822379ad97650dd8606290b82e84d6a9" => :mojave
    sha256 "eef035971497dce1aed7a44dff7ef153b86ae620da32480be3d28be24e3296ca" => :high_sierra
  end

  head do
    url "https://github.com/FreeTDS/freetds.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"
  depends_on "unixodbc"

  def install
    args = %W[
      --prefix=#{prefix}
      --with-tdsver=7.3
      --mandir=#{man}
      --sysconfdir=#{etc}
      --with-unixodbc=#{Formula["unixodbc"].opt_prefix}
      --with-openssl=#{Formula["openssl@1.1"].opt_prefix}
      --enable-sybase-compat
      --enable-krb5
      --enable-odbc-wide
    ]

    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end
    system "make"
    ENV.deparallelize # Or fails to install on multi-core machines
    system "make", "install"
  end

  test do
    system "#{bin}/tsql", "-C"
  end
end
