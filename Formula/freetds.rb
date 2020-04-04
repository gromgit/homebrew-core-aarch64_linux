class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https://www.freetds.org/"
  url "https://www.freetds.org/files/stable/freetds-1.1.26.tar.gz"
  sha256 "a2134ff1852003c0aeed82bd5f7842233ff287c3a14252b84d2653983aff7da1"

  bottle do
    sha256 "363d44ed3a0ec8f9768987bc6d873913dd30818933ea9bb9c290580dbd6d11ab" => :catalina
    sha256 "0af97f13a63bcdc54f9f5963e6a935e2779ae76e11cccfa75b8f60f0affe6574" => :mojave
    sha256 "49347305bf6ae124626f8d74d0660adf73cfee4d36b7cf0b6fbf312041b7aee5" => :high_sierra
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

  uses_from_macos "readline"

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
