class Monetdb < Formula
  desc "Column-store database"
  homepage "https://www.monetdb.org/"
  url "https://www.monetdb.org/downloads/sources/Nov2019-SP3/MonetDB-11.35.19.tar.xz"
  sha256 "eaca588936532f189e6d3d0be4079f195ee5be20e2f8c5738566b75aa86c8f75"

  bottle do
    sha256 "78492a7c2da89a7638b7bcc404f7e58b04ff8ff455cb100dc6d511d4774b4a3d" => :catalina
    sha256 "50e5ae69995fe0301eebd473c0610e01b5f89fa9a53adfd98ca3b18ad1347ba3" => :mojave
    sha256 "ed526afdb710a4006f50d7fda592688993e2805a25fe44297232b24f636e15f3" => :high_sierra
  end

  head do
    url "https://dev.monetdb.org/hg/MonetDB", :using => :hg

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "bison" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "libatomic_ops" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"
  depends_on "pcre"
  depends_on "readline" # Compilation fails with libedit

  def install
    ENV["M4DIRS"] = "#{Formula["gettext"].opt_share}/aclocal" if build.head?
    system "./bootstrap" if build.head?

    system "./configure", "--prefix=#{prefix}",
                          "--enable-assert=no",
                          "--enable-debug=no",
                          "--enable-optimize=yes",
                          "--enable-testing=no",
                          "--with-readline=#{Formula["readline"].opt_prefix}",
                          "--disable-rintegration"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/mclient --help 2>&1")
  end
end
