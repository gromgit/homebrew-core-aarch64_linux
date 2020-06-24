class Curl < Formula
  desc "Get a file from an HTTP, HTTPS or FTP server"
  homepage "https://curl.haxx.se/"
  url "https://curl.haxx.se/download/curl-7.71.0.tar.bz2"
  sha256 "600f00ac2481a89548a4141ddf983fd9386165e1960bac91d0a1c81dca5dd341"

  bottle do
    cellar :any
    sha256 "05dba019f7eea56d52713b9b40591c77caafd3674594843cf06ad2eef8b37cba" => :catalina
    sha256 "e9914a5873014ba49b775293c549a5543466f0d1104b4ef48670b67deee47b01" => :mojave
    sha256 "e43920d8599709909a1f8ab107a63ba2562e3b4737fcf305b4bda0344cdcb2f3" => :high_sierra
  end

  head do
    url "https://github.com/curl/curl.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  keg_only :provided_by_macos

  depends_on "pkg-config" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@1.1"
  end

  def install
    system "./buildconf" if build.head?

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --with-secure-transport
      --without-ca-bundle
      --without-ca-path
    ]

    system "./configure", *args
    system "make", "install"
    system "make", "install", "-C", "scripts"
    libexec.install "lib/mk-ca-bundle.pl"
  end

  test do
    # Fetch the curl tarball and see that the checksum matches.
    # This requires a network connection, but so does Homebrew in general.
    filename = (testpath/"test.tar.gz")
    system "#{bin}/curl", "-L", stable.url, "-o", filename
    filename.verify_checksum stable.checksum

    system libexec/"mk-ca-bundle.pl", "test.pem"
    assert_predicate testpath/"test.pem", :exist?
    assert_predicate testpath/"certdata.txt", :exist?
  end
end
